package repository

import (
	"fmt"
	"backEnd/internal/outbound/repository/theme"
	"backEnd/internal/outbound/repository/user"

	"go.uber.org/dig"
)

type Repository struct {
	dig.In

	Theme theme.Repository
	User user.Repository
}

func Register(container *dig.Container) error {
	if err := container.Provide(theme.New); err != nil {
		return fmt.Errorf("[DI] error provide theme repository: %+v", err)
	}
	if err := container.Provide(user.New); err != nil {
		return fmt.Errorf("[DI] error provide user repository: %+v", err)
	}

	return nil
}
