package user

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		Create(ctx context.Context, user model.RequestRegister) error
		Get(ctx context.Context, request model.RequestGetUser) (model.User, error)
		UpdateCoin(ctx context.Context, userId string, coin int) error
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
