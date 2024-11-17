package outbound

import (
	"fmt"
	"backEnd/internal/outbound/repository"

	"go.uber.org/dig"
)

type Outbound struct {
	dig.In

	Repositories repository.Repository
}

func Register(container *dig.Container) error {
	if err := repository.Register(container); err != nil {
		return fmt.Errorf("[DI] error provide outbound repository: %+v", err)
	}

	return nil
}