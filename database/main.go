package main

import (
	migration "database/dbMigration"
	postgre "database/migrations/postgre"
)

func main() {
	migration.New().WithPostgre(postgre.InitializeMigrations).Run()
}
