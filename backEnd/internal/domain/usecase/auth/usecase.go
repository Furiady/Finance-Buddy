package auth

import (
	"backEnd/internal/domain/model"
	"backEnd/internal/outbound"
	"backEnd/pkg/resource"
	"context"
	"net/http"
)

type (
	UseCase interface {
		Login(ctx context.Context, request model.LoginRequest) (*http.Cookie, error)
		Register(ctx context.Context, request model.RegisterRequest) error
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
