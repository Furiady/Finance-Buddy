package http

import (
	pkgResource "backEnd/pkg/resource"
	sdkHttpMiddleware "backEnd/cmd/appRunner/middleware/http"
	"backEnd/internal/inbound/http/v1/theme"

	"github.com/gin-gonic/gin"
	"go.uber.org/dig"
)

type Http struct {
	dig.In

	Resource pkgResource.Resource

	Theme theme.Controller
}

func (h Http) Routes(gn *gin.Engine) {
	gn.Use(sdkHttpMiddleware.AppContextGin())
	base := gn.Group(h.Resource.ConfigApp.BasePath)

	//V1
	v1 := base.Group("public/api/v1")

	theme.RegisterHandlers(v1, theme.NewStrictHandler(&h.Theme, nil))
}
