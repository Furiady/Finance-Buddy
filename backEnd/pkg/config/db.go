package config

import "time"

type (
	DBConfig struct {
		Host                  string        `mapstructure:"DB_HOST"`
		Port                  int           `mapstructure:"DB_PORT"`
		DBName                string        `mapstructure:"DB_NAME"`
		DBSchema              string        `mapstructure:"DB_SCHEMA"`
		User                  string        `mapstructure:"DB_USER"`
		Password              string        `mapstructure:"DB_PASSWORD"`
		MaxIdleConnection     int           `mapstructure:"DB_MAX_IDLE_CONNECTION"`
		MaxOpenConnection     int           `mapstructure:"DB_MAX_OPEN_CONNECTION"`
		MaxLifetimeConnection time.Duration `mapstructure:"DB_MAX_LIFETIME_CONNECTION"`
		LogMode               bool          `mapstructure:"DB_LOG_MODE"`
	}
)

func NewDBConfig() (DBConfig, error) {
	config := DBConfig{}

	if err := NewFromENV(&config); err != nil {
		return DBConfig{}, err
	}

	return config, nil
}
