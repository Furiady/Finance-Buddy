package postgre

import (
	"gorm.io/gorm"
	"database/dbMigration/helper/file"
)

type migration_20250209150306 struct {
	Conn *gorm.DB
}

// NOTE: DO NOT CHANGE MIGRATION Version
func (m *migration_20250209150306) Version() uint64 {
	return uint64(20250209150306)
}

// NOTE: DO NOT CHANGE MIGRATION Name
func (m *migration_20250209150306) Name() string {
	return "add_themes"
}

func (m *migration_20250209150306) Migrate() error {
	script, err := file.ReadToString("./scripts/postgre/20250209150306_add_themes_migrate.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}

func (m *migration_20250209150306) Rollback() error {
	script, err := file.ReadToString("./scripts/postgre/20250209150306_add_themes_rollback.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}
