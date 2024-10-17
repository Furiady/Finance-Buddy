package postgre

import (
	"database/sql"
	"fmt"
	"sync"

	"database/dbMigration/config"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	postgreConnection *gorm.DB
	once              sync.Once
)

func GetPostgre() (*gorm.DB, error) {
	var err error
	once.Do(func() {
		cfg := config.GetConfig()

		connectionURI := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s search_path=%s sslmode=disable",
			cfg.PostgreSQLAddress, cfg.PostgreSQLPort, cfg.PostgreSQLUsername, cfg.PostgreSQLPassword, cfg.PostgreSQLDbName, cfg.PostgreSQLSchema)

		postgreConnection, err = gorm.Open(postgres.Open(connectionURI), &gorm.Config{})
		if err != nil {
			err = fmt.Errorf("failed to open postgre connection: %+v", err)
			return
		}

		var sqlDb *sql.DB
		sqlDb, err = postgreConnection.DB()
		if err != nil {
			err = fmt.Errorf("failed to open postgre connection: %+v", err)
			return
		}

		sqlDb.SetMaxIdleConns(cfg.PostgreSQLMaxIdleConnection)
		sqlDb.SetMaxOpenConns(cfg.PostgreSQLMaxOpenConnection)
		sqlDb.SetConnMaxLifetime(cfg.PostgreSQLMaxLifetimeConnection)
	})
	if err != nil {
		return nil, err
	}
	return postgreConnection, nil
}
