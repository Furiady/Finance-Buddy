package resource

import (
	"fmt"
	"backEnd/pkg/resource/injection"

	"go.uber.org/dig"
)

func Register(container *dig.Container) error {
	if err := container.Provide(injection.NewDatabaseSQL); err != nil {
		return fmt.Errorf("[DI] cannot initialize databaseSQL: %+v", err)
	}
	
	return nil
}
