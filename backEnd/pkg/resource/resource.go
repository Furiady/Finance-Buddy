package resource

import (
	"backEnd/pkg/config"
	"backEnd/pkg/resource/injection"
	"go.uber.org/dig"
)

type (
	Resource struct {
		dig.In

		ConfigApp         config.AppConfig
		ConfigDB          config.DBConfig

		DatabaseSQL injection.SQL
	}
)
