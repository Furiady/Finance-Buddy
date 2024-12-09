package pet

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		GetAll(ctx context.Context, userId string) (model.Pets, error)
		Get(ctx context.Context, petId string) (model.Pet, error)
		CheckStatusOwned(ctx context.Context, userId string, petId string) error
		UpdateStatusOwned(ctx context.Context, userId string, petId string) error
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
