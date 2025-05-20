package postgre

import (
	"gorm.io/gorm"
	"database/dbMigration/helper/file"
)

type migration_20250209145844 struct {
	Conn *gorm.DB
}

// NOTE: DO NOT CHANGE MIGRATION Version
func (m *migration_20250209145844) Version() uint64 {
	return uint64(20250209145844)
}

// NOTE: DO NOT CHANGE MIGRATION Name
func (m *migration_20250209145844) Name() string {
	return "add_pets"
}

func (m *migration_20250209145844) Migrate() error {
	script, err := file.ReadToString("./scripts/postgre/20250209145844_add_pets_migrate.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}

func (m *migration_20250209145844) Rollback() error {
	script, err := file.ReadToString("./scripts/postgre/20250209145844_add_pets_rollback.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}
