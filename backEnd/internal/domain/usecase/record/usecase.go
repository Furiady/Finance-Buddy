package record

import (
	"backEnd/internal/domain/model"
	"backEnd/internal/outbound"
	"backEnd/pkg/resource"
	"context"
)

type (
	UseCase interface {
		Create(ctx context.Context, request model.RequestCreateRecord) error
		Delete(ctx context.Context, recordId string) error
		Get(ctx context.Context, recordId string) (model.Record, error)
		GetAll(ctx context.Context, request model.RequestGetAllRecord) (model.Records, error)
		GetTotalByCategory(ctx context.Context, request model.RequestGetTotalByCategory) (map[string]int64, error)
		GetTotalByType(ctx context.Context, request model.RequestGetTotalByType) (map[string]int64, error)
		Update(ctx context.Context, request model.RequestUpdateRecord) error
	}

	useCase struct {
		resource resource.Resource
		outbound outbound.Outbound
	}
)

func New(resource resource.Resource, outbound outbound.Outbound) UseCase {
	return &useCase{
		resource: resource,
		outbound: outbound,
	}
}
