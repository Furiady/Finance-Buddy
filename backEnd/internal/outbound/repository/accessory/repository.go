package accessory

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		GetAll(ctx context.Context, userId string) (model.Accessories, error)
		Get(ctx context.Context, accessoryId string) (model.Accessory, error)
		CheckStatusOwned(ctx context.Context, userId string, accessoryId string) error
		UpdateStatusOwned(ctx context.Context, userId string, accessoryId string) error
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
