package postgre

import (
	"gorm.io/gorm"
	"database/dbMigration/helper/file"
)

type migration_20250209144337 struct {
	Conn *gorm.DB
}

// NOTE: DO NOT CHANGE MIGRATION Version
func (m *migration_20250209144337) Version() uint64 {
	return uint64(20250209144337)
}

// NOTE: DO NOT CHANGE MIGRATION Name
func (m *migration_20250209144337) Name() string {
	return "update_quests_table"
}

func (m *migration_20250209144337) Migrate() error {
	script, err := file.ReadToString("./scripts/postgre/20250209144337_update_quests_table_migrate.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}

func (m *migration_20250209144337) Rollback() error {
	script, err := file.ReadToString("./scripts/postgre/20250209144337_update_quests_table_rollback.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}
