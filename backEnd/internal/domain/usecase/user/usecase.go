package user

import (
	"backEnd/internal/domain/model"
	"backEnd/internal/outbound"
	"backEnd/pkg/resource"
	"context"
)

type (
	UseCase interface {
		GetUser(ctx context.Context) (model.User, error)
		GetUserAssets(ctx context.Context) (model.UserAssets, error)
		GetUserLiabilities(ctx context.Context) (model.UserLiabilities, error)
		PostUserGamification(ctx context.Context, gamification string) error
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
