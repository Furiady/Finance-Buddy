package outbound

import (
	"backEnd/internal/outbound/firebase"
	"backEnd/internal/outbound/repository"
	"fmt"

	"go.uber.org/dig"
)

type Outbound struct {
	dig.In

	Repositories repository.Repository
	Firebase     firebase.Firebase
}

func Register(container *dig.Container) error {
	if err := repository.Register(container); err != nil {
		return fmt.Errorf("[DI] error provide outbound repository: %+v", err)
	}
	if err := firebase.Register(container); err != nil {
		return fmt.Errorf("[DI] error provide outbound firebase: %+v", err)
	}

	return nil
}
