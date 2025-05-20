package postgre

import (
	"gorm.io/gorm"
	"database/dbMigration/helper/file"
)

type migration_20250222144410 struct {
	Conn *gorm.DB
}

// NOTE: DO NOT CHANGE MIGRATION Version
func (m *migration_20250222144410) Version() uint64 {
	return uint64(20250222144410)
}

// NOTE: DO NOT CHANGE MIGRATION Name
func (m *migration_20250222144410) Name() string {
	return "add_column_gamification"
}

func (m *migration_20250222144410) Migrate() error {
	script, err := file.ReadToString("./scripts/postgre/20250222144410_add_column_gamification_migrate.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}

func (m *migration_20250222144410) Rollback() error {
	script, err := file.ReadToString("./scripts/postgre/20250222144410_add_column_gamification_rollback.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}
