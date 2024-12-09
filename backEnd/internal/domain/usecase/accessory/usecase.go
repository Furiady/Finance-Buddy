package accessory

import (
	"backEnd/internal/domain/model"
	"backEnd/internal/outbound"
	"backEnd/pkg/resource"
	"context"
)

type (
	UseCase interface {
		GetAll(ctx context.Context) (model.Accessories, error)
		BuyAccessory(ctx context.Context, accessoryId string) error
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
