package config

import (
	"errors"
	"os"
	"sync"
	"time"

	"github.com/sirupsen/logrus"
	sdkConfig "gitlab.banksinarmas.com/go/sdkv2/config"
)

var (
	configuration EnvConfig
	once          sync.Once
)

type (
	EnvConfig struct {
		// - MySQL connection
		MySQLAddress               string        `mapstructure:"MY_SQL_ADDRESS"`
		MySQLUsername              string        `mapstructure:"MY_SQL_USERNAME"`
		MySQLPassword              string        `mapstructure:"MY_SQL_PASSWORD"`
		MySQLDbName                string        `mapstructure:"MY_SQL_DB_NAME"`
		MySQLMaxIdleConnection     int           `mapstructure:"MY_SQL_MAX_IDLE_CONNECTION"`
		MySQLMaxOpenConnection     int           `mapstructure:"MY_SQL_MAX_OPEN_CONNECTION"`
		MySQLMaxLifetimeConnection time.Duration `mapstructure:"MY_SQL_MAX_LIFETIME_CONNECTION"`
		MySQLLogMode               bool          `mapstructure:"MY_SQL_LOG_MODE" default:"false"`

		// - Postgres connection
		PostgreSQLAddress               string        `mapstructure:"POSTGRE_SQL_ADDRESS"`
		PostgreSQLPort                  string        `mapstructure:"POSTGRE_SQL_PORT"`
		PostgreSQLUsername              string        `mapstructure:"POSTGRE_SQL_USERNAME"`
		PostgreSQLPassword              string        `mapstructure:"POSTGRE_SQL_PASSWORD"`
		PostgreSQLDbName                string        `mapstructure:"POSTGRE_SQL_DB_NAME"`
		PostgreSQLSchema                string        `mapstructure:"POSTGRE_SQL_SCHEMA"`
		PostgreSQLMaxIdleConnection     int           `mapstructure:"POSTGRE_SQL_MAX_IDLE_CONNECTION"`
		PostgreSQLMaxOpenConnection     int           `mapstructure:"POSTGRE_SQL_MAX_OPEN_CONNECTION"`
		PostgreSQLMaxLifetimeConnection time.Duration `mapstructure:"POSTGRE_SQL_MAX_LIFETIME_CONNECTION"`
		PostgreSQLLogMode               bool          `mapstructure:"POSTGRE_SQL_LOG_MODE" default:"false"`
	}
)

func (e EnvConfig) validate() error {
	if e.MySQLAddress != "" {
		if e.MySQLUsername == "" || e.MySQLDbName == "" {
			return errors.New("MY_SQL_USERNAME, MY_SQL_PASSWORD, MY_SQL_DB_NAME is required")
		}
		if e.MySQLMaxOpenConnection == 0 || e.MySQLMaxIdleConnection == 0 || e.MySQLMaxLifetimeConnection == 0 {
			return errors.New("MY_SQL_MAX_OPEN_CONNECTION, MY_SQL_MAX_IDLE_CONNECTION, MY_SQL_MAX_LIFETIME_CONNECTION is required")
		}
	}

	if e.PostgreSQLAddress != "" {
		if e.PostgreSQLUsername == "" || e.PostgreSQLDbName == "" || e.PostgreSQLSchema == "" {
			return errors.New("POSTGRE_SQL_USERNAME, POSTGRE_SQL_PASSWORD, POSTGRE_SQL_DB_NAME, POSTGRE_SQL_SCHEMA is required")
		}
		if e.PostgreSQLMaxOpenConnection == 0 || e.PostgreSQLMaxIdleConnection == 0 || e.PostgreSQLMaxLifetimeConnection == 0 {
			return errors.New("POSTGRE_SQL_MAX_OPEN_CONNECTION, POSTGRE_SQL_MAX_IDLE_CONNECTION, POSTGRE_SQL_MAX_LIFETIME_CONNECTION is required")
		}
	}

	return nil
}

func GetConfig() EnvConfig {
	once.Do(func() {
		var (
			env      = os.Getenv("ENV")
			filePath *string
		)

		if env == "" || env == "local" {
			s := "variables/.env"
			filePath = &s
		} else {
			filePath = nil
		}

		if err := sdkConfig.NewFromEnv(filePath, &configuration); err != nil {
			logrus.StandardLogger().Fatal(err)
		}

		if err := configuration.validate(); err != nil {
			logrus.StandardLogger().Fatal(err)
		}

		if configuration.PostgreSQLAddress != "" {
			if configuration.PostgreSQLPort == "" {
				configuration.PostgreSQLPort = "5432"
			}
			if configuration.PostgreSQLSchema == "" {
				configuration.PostgreSQLSchema = "public"
			}
		}
	})
	return configuration
}
