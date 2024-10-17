package pkgDi

import (
	"sync"
	"backEnd/internal/outbound"
	"backEnd/internal/domain"
	"backEnd/pkg/config"
	"backEnd/pkg/resource"

	"go.uber.org/dig"
)

var (
	container *dig.Container
	once      sync.Once
)

func Container() (*dig.Container, error) {
	var outer error

	once.Do(func() {
		container = dig.New()
		if err := config.Register(container); err != nil {
			outer = err
			return
		}
		if err := resource.Register(container); err != nil {
			outer = err
			return
		}
		if err := domain.Register(container); err != nil {
			outer = err
			return
		}
		if err := outbound.Register(container); err != nil {
			outer = err
			return
		}
	})
	if outer != nil {
		return nil, outer
	}

	return container, nil
}
