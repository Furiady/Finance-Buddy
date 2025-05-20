package record

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		Create(ctx context.Context, request model.RequestCreateRecord) error
		Update(ctx context.Context, request model.RequestUpdateRecord) error
		Delete(ctx context.Context, request model.RequestDeleteRecord) error
		Get(ctx context.Context, request model.RequestFindRecord) (model.Record, error)
		GetAll(ctx context.Context, request model.RequestGetAllRecord) (model.Records, error)
		Count(ctx context.Context, request model.RequestCount) (int64, error)
		GetTotalByType(ctx context.Context, request model.RequestGetTotalByType) (map[string]int64, error)
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
