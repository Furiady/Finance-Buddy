package usecase

import (
	"backEnd/internal/domain/usecase/auth"
	"backEnd/internal/domain/usecase/theme"
	"fmt"

	"go.uber.org/dig"
)

type UseCase struct {
	dig.In

	Theme theme.UseCase
	Auth  auth.UseCase
}

func Register(container *dig.Container) error {
	if err := container.Provide(theme.New); err != nil {
		return fmt.Errorf("[DI] error provide theme use case: %+v", err)
	}
	if err := container.Provide(auth.New); err != nil {
		return fmt.Errorf("[DI] error provide auth use case: %+v", err)
	}

	return nil
}
