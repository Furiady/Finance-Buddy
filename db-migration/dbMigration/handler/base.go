package handler

import (
	"sync"

	"github.com/Furiady/skripsi/db-migration/dbMigration/config"
	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/connection"
	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/migration"
	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/migration/postgre"
	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/version"
	"github.com/Furiady/skripsi/db-migration/dbMigration/migrator"
	"github.com/pkg/errors"
	"github.com/sirupsen/logrus"
)

var (
	instance handler
	once     sync.Once
)

type (
	NewRequestDTO struct {
		Version       version.Version
		MigrationType string
		MigrationName string
	}
	handler struct {
		connections []migration.Tool
		config      config.EnvConfig
	}
)

func GetHandler() handler {
	once.Do(func() {
		instance = handler{
			config: config.GetConfig(),
		}
	})
	return instance
}

var mappingConnection = map[string]func(m migrator.Migrator) (migration.Tool, error){
	connection.Postgre: func(m migrator.Migrator) (migration.Tool, error) {
		return postgre.New(m)
	},
}

func (h *handler) initializeConnection(m migrator.Migrator, types []string) error {
	for _, t := range types {
		f, ok := mappingConnection[t]
		if !ok {
			continue
		}
		h.addConnections(m, f)
	}

	if len(h.connections) < 1 {
		return errors.New("no connection created")
	}
	return nil
}

func (h *handler) addConnections(m migrator.Migrator, f func(m migrator.Migrator) (migration.Tool, error)) {
	conn, err := f(m)
	if err != nil {
		logrus.StandardLogger().Warnf("failed add connection: %s", err.Error())
	} else {
		h.connections = append(h.connections, conn)
	}
}
