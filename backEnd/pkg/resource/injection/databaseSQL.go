package injection

import (
	"backEnd/pkg/config"
	"fmt"

	postgres "go.elastic.co/apm/module/apmgormv2/v2/driver/postgres"
	"gorm.io/gorm"
)

type SQL struct {
	UrDB *gorm.DB
}

func NewDatabaseSQL(config config.DBConfig) (SQL, error) {
	var (
		db  *gorm.DB
		err error
	)

	connectionURI := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s search_path=%s sslmode=disable timezone=Asia%%2FJakarta",
		config.Host, config.Port, config.User, config.Password, config.DBName, config.DBSchema)

	db, err = gorm.Open(postgres.Open(connectionURI), &gorm.Config{
		SkipDefaultTransaction: true,
	})
	if err != nil {
		return SQL{}, fmt.Errorf("failed to open postgresql connection: %+v", err)
	}

	sqlDB, err := db.DB()
	if err != nil {
		return SQL{}, fmt.Errorf("failed to open postgresql connection: %+v", err)
	}

	sqlDB.SetMaxIdleConns(config.MaxIdleConnection)
	sqlDB.SetMaxOpenConns(config.MaxOpenConnection)
	sqlDB.SetConnMaxLifetime(config.MaxLifetimeConnection)

	return SQL{
		UrDB: db,
	}, nil
}
