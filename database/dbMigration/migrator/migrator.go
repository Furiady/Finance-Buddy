package migrator

import (
	"database/dbMigration/helper/migration"

	"gorm.io/gorm"
)

type (
	Migrator struct {
		postgre func(conn *gorm.DB) []migration.Migration
	}
)

func New() *Migrator {
	return &Migrator{}
}

func (m Migrator) Postgre() func(conn *gorm.DB) []migration.Migration {
	return m.postgre
}

func (m *Migrator) WithPostgre(f func(conn *gorm.DB) []migration.Migration) *Migrator {
	m.postgre = f
	return m
}
