package templates

const InitializeTemplate = `// GENERATED CODE, DO NOT EDIT THIS FILE
package {{.MigrationType}}

import (
	"database/dbMigration/helper/migration"

	"gorm.io/gorm"
)

func InitializeMigrations(conn *gorm.DB) []migration.Migration {
	var migrations = make([]migration.Migration, 0)
	{{range $version := .Versions}}migrations = append(migrations, Migration_{{$version}}(conn))
	{{ end }}return migrations
}
{{range $version := .Versions}}
func Migration_{{$version}}(conn *gorm.DB) migration.Migration {
	return &migration_{{$version}}{
		Conn: conn,
	}
}
{{end}}
`
