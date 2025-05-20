package repository

import (
	"backEnd/internal/outbound/repository/accessory"
	"backEnd/internal/outbound/repository/asset_category"
	"backEnd/internal/outbound/repository/pet"
	"backEnd/internal/outbound/repository/quest"
	"backEnd/internal/outbound/repository/record"
	"backEnd/internal/outbound/repository/theme"
	"backEnd/internal/outbound/repository/user"
	"backEnd/internal/outbound/repository/user_asset"
	"backEnd/internal/outbound/repository/user_quest"
	"fmt"

	"go.uber.org/dig"
)

type Repository struct {
	dig.In

	Theme         theme.Repository
	User          user.Repository
	Accessory     accessory.Repository
	Pet           pet.Repository
	Record        record.Repository
	Quest         quest.Repository
	AssetCategory asset_category.Repository
	UserAsset     user_asset.Repository
	UserQuest     user_quest.Repository
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
	if err := container.Provide(record.New); err != nil {
		return fmt.Errorf("[DI] error provide record repository: %+v", err)
	}
	if err := container.Provide(quest.New); err != nil {
		return fmt.Errorf("[DI] error provide quest repository: %+v", err)
	}
	if err := container.Provide(asset_category.New); err != nil {
		return fmt.Errorf("[DI] error provide asset_category repository: %+v", err)
	}
	if err := container.Provide(user_asset.New); err != nil {
		return fmt.Errorf("[DI] error provide user_asset repository: %+v", err)
	}
	if err := container.Provide(user_quest.New); err != nil {
		return fmt.Errorf("[DI] error provide user_quest repository: %+v", err)
	}

	return nil
}
