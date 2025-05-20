package user_asset

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		Get(ctx context.Context, request model.RequestGetUserAsset) (model.UserAsset, error)
		GetAll(ctx context.Context, request model.RequestGetUserAssets) (model.UserAssets, error)
		Save(ctx context.Context, request model.RequestSaveUserAsset) error
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
