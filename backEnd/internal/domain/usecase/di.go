package usecase

import (
	"backEnd/internal/domain/usecase/accessory"
	"backEnd/internal/domain/usecase/auth"
	"backEnd/internal/domain/usecase/pet"
	"backEnd/internal/domain/usecase/quest"
	"backEnd/internal/domain/usecase/record"
	"backEnd/internal/domain/usecase/theme"
	"backEnd/internal/domain/usecase/user"
	"fmt"

	"go.uber.org/dig"
)

type UseCase struct {
	dig.In

	Theme     theme.UseCase
	Auth      auth.UseCase
	Accessory accessory.UseCase
	Pet       pet.UseCase
	User      user.UseCase
	Record    record.UseCase
	Quest     quest.UseCase
}

func Register(container *dig.Container) error {
	if err := container.Provide(theme.New); err != nil {
		return fmt.Errorf("[DI] error provide theme use case: %+v", err)
	}
	if err := container.Provide(accessory.New); err != nil {
		return fmt.Errorf("[DI] error provide accessory use case: %+v", err)
	}
	if err := container.Provide(auth.New); err != nil {
		return fmt.Errorf("[DI] error provide auth use case: %+v", err)
	}
	if err := container.Provide(pet.New); err != nil {
		return fmt.Errorf("[DI] error provide pet use case: %+v", err)
	}
	if err := container.Provide(user.New); err != nil {
		return fmt.Errorf("[DI] error provide user use case: %+v", err)
	}
	if err := container.Provide(record.New); err != nil {
		return fmt.Errorf("[DI] error provide record use case: %+v", err)
	}
	if err := container.Provide(quest.New); err != nil {
		return fmt.Errorf("[DI] error provide quest use case: %+v", err)
	}

	return nil
}
