package record

import (
	pkgResource "backEnd/pkg/resource"
	"context"
	"mime/multipart"
)

type (
	Firebase interface {
		Upload(ctx context.Context, filePath string, file multipart.File) error
	}

	firebase struct {
		resource pkgResource.Resource
	}
)

func New(resource pkgResource.Resource) Firebase {
	return &firebase{
		resource: resource,
	}
}
