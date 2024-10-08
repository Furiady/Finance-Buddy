package main

import (
	migration "github.com/Furiady/skripsi/db-migration/dbMigration"
	postgre "github.com/Furiady/skripsi/db-migration/migrations/postgre"
)

func main() {
	migration.New().WithPostgre(postgre.InitializeMigrations).Run()
}
