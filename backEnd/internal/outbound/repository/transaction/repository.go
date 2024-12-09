package transaction

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		Create(ctx context.Context, request model.RequestCreateTransaction) error
		Update(ctx context.Context, request model.RequestUpdateTransaction) error
		Delete(ctx context.Context, request model.RequestDeleteTransaction) error
		Get(ctx context.Context, request model.RequestFindTransaction) (model.Transaction, error)
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
