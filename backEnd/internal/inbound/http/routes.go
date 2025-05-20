package http

import (
	sdkHttpMiddleware "backEnd/cmd/appRunner/middleware/http"
	"backEnd/internal/inbound/http/v1/accessory"
	"backEnd/internal/inbound/http/v1/auth"
	"backEnd/internal/inbound/http/v1/pet"
	"backEnd/internal/inbound/http/v1/quest"
	"backEnd/internal/inbound/http/v1/record"
	"backEnd/internal/inbound/http/v1/theme"
	"backEnd/internal/inbound/http/v1/user"
	httpMiddleware "backEnd/pkg/middleware/http"
	pkgResource "backEnd/pkg/resource"

	"github.com/gin-gonic/gin"
	"go.uber.org/dig"
)

type Http struct {
	dig.In

	Resource pkgResource.Resource

	Theme     theme.Controller
	Auth      auth.Controller
	Accessory accessory.Controller
	Pet       pet.Controller
	User      user.Controller
	Record    record.Controller
	Quest     quest.Controller
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

	accessory.RegisterHandlers(v1, accessory.NewStrictHandler(&h.Accessory, []accessory.StrictMiddlewareFunc{
		httpMiddleware.ValidateToken(h.Resource.ConfigApp.Environment, h.Resource.ConfigApp.TokenSecret),
	}))

	pet.RegisterHandlers(v1, pet.NewStrictHandler(&h.Pet, []pet.StrictMiddlewareFunc{
		httpMiddleware.ValidateToken(h.Resource.ConfigApp.Environment, h.Resource.ConfigApp.TokenSecret),
	}))

	user.RegisterHandlers(v1, user.NewStrictHandler(&h.User, []user.StrictMiddlewareFunc{
		httpMiddleware.ValidateToken(h.Resource.ConfigApp.Environment, h.Resource.ConfigApp.TokenSecret),
	}))

	record.RegisterHandlers(v1, record.NewStrictHandler(&h.Record, []record.StrictMiddlewareFunc{
		httpMiddleware.ValidateToken(h.Resource.ConfigApp.Environment, h.Resource.ConfigApp.TokenSecret),
	}))

	quest.RegisterHandlers(v1, quest.NewStrictHandler(&h.Quest, []quest.StrictMiddlewareFunc{
		httpMiddleware.ValidateToken(h.Resource.ConfigApp.Environment, h.Resource.ConfigApp.TokenSecret),
	}))
}
