package handler

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"database/dbMigration/helper"
	"database/dbMigration/helper/connection"
	"database/dbMigration/helper/migration"
	"database/dbMigration/helper/version"

	"github.com/pkg/errors"
	"github.com/sirupsen/logrus"
)

func (h handler) New(version version.Version, migrationType string, migrationName string) error {
	if !connection.IsValid(migrationType) {
		return errors.New(fmt.Sprintf("migration type %s is not supported", migrationType))
	}

	neutralizedName := strings.ReplaceAll(migrationName, " ", "_")
	migrationsPath := fmt.Sprintf("migrations/%s", migrationType)
	scriptsPath := fmt.Sprintf("scripts/%s", migrationType)

	fileName := fmt.Sprintf("%d_%s.go", version, neutralizedName)
	extension := "sql"
	migrateFileName := fmt.Sprintf("%d_%s_migrate.%s", version, neutralizedName, extension)
	rollbackFileName := fmt.Sprintf("%d_%s_rollback.%s", version, neutralizedName, extension)

	// NOTE: create migrations file
	logrus.StandardLogger().Infof("[%s] creating migration file version: %d_%s.go", strings.ToUpper(migrationType),
		version, neutralizedName)
	if err := os.MkdirAll(migrationsPath, os.ModePerm); err != nil {
		return err
	}
	if err := helper.CreateMigrations(filepath.Join(migrationsPath, fileName),
		helper.MigrationRequestDTO{
			Version:       uint64(version),
			MigrationType: migrationType,
			MigrationName: migrationName,
		}); err != nil {
		logrus.StandardLogger().Errorf("[%s] error creating migration file version: %d_%s.go: %s",
			strings.ToUpper(migrationType), version, neutralizedName, err.Error())
		return err
	}

	if err := os.MkdirAll(scriptsPath, os.ModePerm); err != nil {
		return err
	}

	// NOTE: create migrate script file
	if err := helper.CreateEmptyFile(filepath.Join(scriptsPath, migrateFileName)); err != nil {
		logrus.StandardLogger().Errorf("[%s] error creating empty migration file version: %d_%s.go: %s",
			strings.ToUpper(migrationType), version, neutralizedName, err.Error())
		return err
	}

	// NOTE: create rollback script file
	if err := helper.CreateEmptyFile(filepath.Join(scriptsPath, rollbackFileName)); err != nil {
		logrus.StandardLogger().Errorf("[%s] error creating rollback migration file version: %d_%s.go: %s",
			strings.ToUpper(migrationType), version, neutralizedName, err.Error())
		return err
	}

	// NOTE: create migrations initialization
	logrus.StandardLogger().Infof("[%s] initialize migration file version: %d_%s.go",
		strings.ToUpper(migrationType), version, neutralizedName)
	files := migration.LoadMigrations(migrationType)
	if err := helper.CreateInitialization(filepath.Join(migrationsPath, "initialize.go"),
		helper.InitializeRequestDTO{
			MigrationType: migrationType,
			Versions:      files,
		}); err != nil {
		logrus.StandardLogger().Errorf("[%s] error initialize migration file version: %d_%s.go: %s",
			strings.ToUpper(migrationType), version, neutralizedName, err.Error())
		return err
	}

	logrus.StandardLogger().Infof("[%s] finish migration file version: %d_%s.go",
		strings.ToUpper(migrationType), version, neutralizedName)
	return nil
}
