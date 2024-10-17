package domain

import (
	"go.uber.org/dig"
)

type UseCase struct {
	dig.In

}

func Register(container *dig.Container) error {
	return nil
}