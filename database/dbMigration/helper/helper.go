package helper

import (
	"os"
	"text/template"

	"database/dbMigration/helper/templates"
)

type (
	MigrationRequestDTO struct {
		Version       uint64
		MigrationType string
		MigrationName string
	}
	InitializeRequestDTO struct {
		MigrationType string
		Versions      []string
	}
)

func CreateEmptyFile(outputPath string) error {
	f, err := os.Create(outputPath)
	if err != nil {
		return err
	}
	_ = f.Close()
	return nil
}

func CreateMigrations(outputPath string, data MigrationRequestDTO) error {
	tmpl, err := template.New(outputPath).Parse(templates.MigrationsTemplate)
	if err != nil {
		return err
	}

	f, err := os.Create(outputPath)
	if err != nil {
		return err
	}
	defer f.Close()

	err = tmpl.Execute(f, data)
	if err != nil {
		return err
	}
	return nil
}

func CreateInitialization(outputPath string, data InitializeRequestDTO) error {
	tmpl, err := template.New(outputPath).Parse(templates.InitializeTemplate)
	if err != nil {
		return err
	}

	f, err := os.Create(outputPath)
	if err != nil {
		return err
	}
	defer f.Close()

	err = tmpl.Execute(f, data)
	if err != nil {
		return err
	}
	return nil
}
