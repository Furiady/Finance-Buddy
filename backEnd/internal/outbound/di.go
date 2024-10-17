package outbound

import (
	"go.uber.org/dig"
)

type Outbound struct {
	dig.In
}

func Register(container *dig.Container) error {
	return nil
}
