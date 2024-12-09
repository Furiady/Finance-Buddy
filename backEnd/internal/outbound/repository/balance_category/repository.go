package balance_category

import (
	pkgResource "backEnd/pkg/resource"
	"context"
)

type (
	Repository interface {
		GetIdByName(ctx context.Context, category string) (*string, error)
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
