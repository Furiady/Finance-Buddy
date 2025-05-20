package quest

import (
	domain "backEnd/internal/domain"
	pkgResource "backEnd/pkg/resource"

	"go.uber.org/dig"
)

type Controller struct {
	dig.In

	Domain   domain.Domain
	Resource pkgResource.Resource
}

var _ StrictServerInterface = (*Controller)(nil)
