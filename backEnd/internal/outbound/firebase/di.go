package firebase

import (
	"backEnd/internal/outbound/firebase/record"
	"fmt"

	"go.uber.org/dig"
)

type Firebase struct {
	dig.In

	Record record.Firebase
}

func Register(container *dig.Container) error {
	if err := container.Provide(record.New); err != nil {
		return fmt.Errorf("[DI] error provide record repository: %+v", err)
	}

	return nil
}
