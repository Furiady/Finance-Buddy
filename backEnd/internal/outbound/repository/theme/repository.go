package theme

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		GetAll(ctx context.Context, userId string) (model.Themes, error)
		Get(ctx context.Context, themeId string) (model.Theme, error)
		CheckStatusOwned(ctx context.Context, userId string, themeId string) error
		UpdateStatusOwned(ctx context.Context, userId string, themeId string) error
	}

	repository struct {
		resource pkgResource.Resource
	}
)

func New(resource pkgResource.Resource) Repository {
	return &repository{
		resource: resource,
	}
}
