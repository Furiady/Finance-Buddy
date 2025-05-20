package quest

import (
	"backEnd/internal/outbound/model"
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		GetAll(ctx context.Context, userId string) (model.Quests, error)
		Get(ctx context.Context, userId string) (model.Quest, error)
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
