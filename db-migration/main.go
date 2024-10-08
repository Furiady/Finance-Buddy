package main

import (
	migration "github.com/Furiady/skripsi/db-migration/dbMigration"
	postgre "github.com/Furiady/skripsi/db-migration/dbMigration/migrations/postgre"
)

func main() {
	migration.New().WithPostgre(postgre.InitializeMigrations).Run()
}
