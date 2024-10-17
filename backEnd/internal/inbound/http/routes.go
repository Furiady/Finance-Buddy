package http

import (
	pkgResource "backEnd/pkg/resource"
	sdkHttpMiddleware "backEnd/cmd/appRunner/middleware/http"

	"github.com/gin-gonic/gin"
	"go.uber.org/dig"
)

type Http struct {
	dig.In

	Resource pkgResource.Resource
}

func (h Http) Routes(gn *gin.Engine) {
	gn.Use(sdkHttpMiddleware.AppContextGin())
	// base := gn.Group(h.Resource.ConfigApp.BasePath)

	// //V1
	// v1 := base.Group("/public/api/v1.0")
}
