package config

import (
	"fmt"

	"go.uber.org/dig"
)

func Register(container *dig.Container) error {
	if err := container.Provide(NewAppConfig); err != nil {
		return fmt.Errorf("[DI] cannot initialize app config: %+v", err)
	}

	if err := container.Provide(NewDBConfig); err != nil {
		return fmt.Errorf("[DI] cannot initialize db config: %+v", err)
	}
	
	return nil
}
