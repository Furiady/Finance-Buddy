package postgre

import (
	"gorm.io/gorm"
	"database/dbMigration/helper/file"
)

type migration_20241009095011 struct {
	Conn *gorm.DB
}

// NOTE: DO NOT CHANGE MIGRATION Version
func (m *migration_20241009095011) Version() uint64 {
	return uint64(20241009095011)
}

// NOTE: DO NOT CHANGE MIGRATION Name
func (m *migration_20241009095011) Name() string {
	return "create_table_user"
}

func (m *migration_20241009095011) Migrate() error {
	script, err := file.ReadToString("./scripts/postgre/20241009095011_create_table_user_migrate.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}

func (m *migration_20241009095011) Rollback() error {
	script, err := file.ReadToString("./scripts/postgre/20241009095011_create_table_user_rollback.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}
