package transaction

import (
	"backEnd/internal/domain/model"
	"backEnd/internal/outbound"
	"backEnd/pkg/resource"
	"context"
)

type (
	UseCase interface {
		Create(ctx context.Context, request model.RequestCreateTransaction) error
		Delete(ctx context.Context, transactionId string) error
		Get(ctx context.Context, transactionId string) (model.Transaction, error)
		Update(ctx context.Context, request model.RequestUpdateTransaction) error
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
