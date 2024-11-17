package domain

import (
	"fmt"
	"backEnd/internal/domain/usecase"

	"go.uber.org/dig"
)

type Domain struct {
	dig.In

	UseCases usecase.UseCase
}

func Register(container *dig.Container) error {
	if err := usecase.Register(container); err != nil {
		return fmt.Errorf("[DI] error provide domain usecase: %+v", err)
	}

	return nil
}