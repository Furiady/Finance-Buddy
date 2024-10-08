package templates

const MigrationsTemplate = `package {{.MigrationType}}

import (
	"gorm.io/gorm"
	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/file"
)

type migration_{{.Version}} struct {
	Conn *gorm.DB
}

// NOTE: DO NOT CHANGE MIGRATION Version
func (m *migration_{{.Version}}) Version() uint64 {
	return uint64({{.Version}})
}

// NOTE: DO NOT CHANGE MIGRATION Name
func (m *migration_{{.Version}}) Name() string {
	return "{{.MigrationName}}"
}

func (m *migration_{{.Version}}) Migrate() error {
	script, err := file.ReadToString("./scripts/{{.MigrationType}}/{{.Version}}_{{.MigrationName}}_migrate.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}

func (m *migration_{{.Version}}) Rollback() error {
	script, err := file.ReadToString("./scripts/{{.MigrationType}}/{{.Version}}_{{.MigrationName}}_rollback.sql")
	if err != nil {
		return err
	}

	if err := m.Conn.Exec(script); err != nil {
		return err.Error
	}

	return nil
}
`
