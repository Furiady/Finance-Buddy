package handler

import (
	"strings"

	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/version"
	"github.com/Furiady/skripsi/db-migration/dbMigration/migrator"
	"github.com/pkg/errors"
	"github.com/sirupsen/logrus"
)

func (h handler) Migrate(m migrator.Migrator, version version.Version, specific bool, verbose bool, migrationTypes ...string) error {
	if err := h.initializeConnection(m, migrationTypes); err != nil {
		return err
	}

	var errorMessage = make([]string, 0)
	for _, connection := range h.connections {
		if err := connection.Check(verbose); err != nil {
			logrus.StandardLogger().Errorf("[%s] error on connection check: %+v", connection.Name(), err.Error())
			errorMessage = append(errorMessage, err.Error())
			continue
		}

		if err := connection.Migrate(version, specific); err != nil {
			logrus.StandardLogger().Errorf("[%s] error on process migration: %+v", connection.Name(), err.Error())
			errorMessage = append(errorMessage, err.Error())
		}
	}

	if len(errorMessage) == 0 {
		return nil
	}
	return errors.New(strings.Join(errorMessage, "\n"))
}
