package sdkServer

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-contrib/gzip"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"go.elastic.co/apm/module/apmgin/v2"

)

type (
	HttpServer struct {
		server                                *http.Server
		gn                                    *gin.Engine
		serviceName, serviceVersion, basePath string
		option                                httpOptions
		ServerTemplate
	}

	BaseResponse struct {
		Message   string `json:"message,omitempty"`
		Timestamp int64  `json:"timestamp,omitempty"`
		Code      string `json:"code,omitempty"`
	}
)

const production = "prd"

func NewHttp(serviceName, serviceVersion, basePath string, opts ...HttpOption) *HttpServer {
	o := defaultHttpOption()
	for _, opt := range opts {
		opt.Apply(&o)
	}

	if o.env == production {
		gin.SetMode(gin.ReleaseMode)
	}

	g := gin.New()

	return &HttpServer{
		gn:             g,
		basePath:       basePath,
		serviceName:    serviceName,
		serviceVersion: serviceVersion,
		option:         o,
	}
}

func (s *HttpServer) Serve(sig chan os.Signal) {
	s.gn.Use(
		gzip.Gzip(gzip.DefaultCompression),
		apmgin.Middleware(s.gn),
		gin.CustomRecovery(func(c *gin.Context, err any) {
			c.JSON(http.StatusInternalServerError, BaseResponse{
				Message: "Internal Server Error",
			})
		}),
		cors.New(cors.Config{
			AllowAllOrigins: true,
			AllowMethods:    []string{"POST", "PUT", "PATCH", "DELETE", "GET"},
			AllowHeaders:    []string{"Content-Type, Authorization, access-control-allow-origin, access-control-allow-headers"},
		}),
		gin.LoggerWithConfig(gin.LoggerConfig{
			SkipPaths: []string{"/api/health/liveness", "/api/health/readiness"},
		}),
	)

	s.ServerTemplate.Serve(sig, ServeParam{
		Serve: func(sig chan os.Signal) {
			logrus.Info("[HTTP-SERVER] starting server") //TODO: integrate with app log
			s.server = &http.Server{
				Addr:    fmt.Sprintf(":%d", s.option.port),
				Handler: s.gn,
			}

			go func() {
				if err := s.server.ListenAndServe(); err != nil {
					logrus.Errorf("[HTTP-SERVER] server interrupted %s", err.Error())
					sig <- os.Interrupt
				}
			}()
			time.Sleep(time.Second)
		},
		Register: func() {
			if s.option.register != nil {
				logrus.Debug("[HTTP-SERVER] starting register hooks")
				s.option.register(s.gn)
			}
		},
		BeforeRun: func() {
			if s.option.beforeRun != nil {
				logrus.Debug("[HTTP-SERVER] starting before run hooks")
				s.option.beforeRun(s.gn)
			}
		},
		AfterRun: func() {
			if s.option.afterRun != nil {
				logrus.Debug("[HTTP-SERVER] starting after run hooks")
				s.option.afterRun(s.gn)
			}
		},
	})
}

func (s *HttpServer) Shutdown() {
	ctx, cancel := context.WithTimeout(context.Background(), s.option.gracefulPeriod)
	defer cancel()

	s.ServerTemplate.Shutdown(ShutdownParam{
		Shutdown: func() {
			logrus.Info("[HTTP-SERVER] shutting down server")
			if err := s.server.Shutdown(ctx); err != nil {
				logrus.Errorf("[HTTP-SERVER] server can not be shutdown %s", err.Error())
			}
		},
		BeforeExit: func() {
			if s.option.beforeExit != nil {
				logrus.Debug("[HTTP-SERVER] starting before exit hooks")
				s.option.beforeExit(s.gn)
			}
		},
		AfterExit: func() {
			if s.option.afterExit != nil {
				logrus.Debug("[HTTP-SERVER] starting after exit hooks")
				s.option.afterExit(s.gn)
			}
		},
	})
}
