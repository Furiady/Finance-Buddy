package repository

import (
	"backEnd/internal/outbound/repository/accessory"
	"backEnd/internal/outbound/repository/balance_category"
	"backEnd/internal/outbound/repository/pet"
	"backEnd/internal/outbound/repository/theme"
	"backEnd/internal/outbound/repository/transaction"
	"backEnd/internal/outbound/repository/user"
	"fmt"

	"go.uber.org/dig"
)

type Repository struct {
	dig.In

	Theme           theme.Repository
	User            user.Repository
	Accessory       accessory.Repository
	Pet             pet.Repository
	Transaction     transaction.Repository
	BalanceCategory balance_category.Repository
}

func Register(container *dig.Container) error {
	if err := container.Provide(theme.New); err != nil {
		return fmt.Errorf("[DI] error provide theme repository: %+v", err)
	}
	if err := container.Provide(user.New); err != nil {
		return fmt.Errorf("[DI] error provide user repository: %+v", err)
	}
	if err := container.Provide(accessory.New); err != nil {
		return fmt.Errorf("[DI] error provide accessory repository: %+v", err)
	}
	if err := container.Provide(pet.New); err != nil {
		return fmt.Errorf("[DI] error provide pet repository: %+v", err)
	}
	if err := container.Provide(transaction.New); err != nil {
		return fmt.Errorf("[DI] error provide transaction repository: %+v", err)
	}
	if err := container.Provide(balance_category.New); err != nil {
		return fmt.Errorf("[DI] error provide balance_category repository: %+v", err)
	}

	return nil
}
