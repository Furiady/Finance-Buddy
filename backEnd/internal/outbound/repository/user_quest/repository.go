package user_quest

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		Get(ctx context.Context, userId string, questId string) (model.UserQuest, error)
		Update(ctx context.Context, request model.UserQuest) error
		Create(ctx context.Context, request model.UserQuest) error
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
