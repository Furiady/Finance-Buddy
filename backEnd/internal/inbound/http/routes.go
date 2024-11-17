package http

import (
	sdkHttpMiddleware "backEnd/cmd/appRunner/middleware/http"
	"backEnd/internal/inbound/http/v1/auth"
	"backEnd/internal/inbound/http/v1/theme"
	httpMiddleware "backEnd/pkg/middleware/http"
	pkgResource "backEnd/pkg/resource"

	"github.com/gin-gonic/gin"
	"go.uber.org/dig"
)

type Http struct {
	dig.In

	Resource pkgResource.Resource

	Theme theme.Controller
	Auth  auth.Controller
}

func (h Http) Routes(gn *gin.Engine) {
	gn.Use(sdkHttpMiddleware.AppContextGin())
	base := gn.Group(h.Resource.ConfigApp.BasePath)

	//V1
	v1 := base.Group("public/api/v1")

	auth.RegisterHandlers(v1, auth.NewStrictHandler(&h.Auth, nil))

	theme.RegisterHandlers(v1, theme.NewStrictHandler(&h.Theme, []theme.StrictMiddlewareFunc{
		httpMiddleware.ValidateToken(h.Resource.ConfigApp.Environment, h.Resource.ConfigApp.TokenSecret),
	}))
}
