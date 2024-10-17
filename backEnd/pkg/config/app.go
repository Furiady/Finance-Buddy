package config

import "time"

type (
	AppConfig struct {
		Environment           string        `mapstructure:"ENV"`
		ServerName            string        `mapstructure:"SERVER_NAME"`
		ServerVersion         string        `mapstructure:"SERVER_VERSION"`
		ServerPort            int           `mapstructure:"SERVER_PORT"`
		BasePath              string        `mapstructure:"BASE_PATH"`
		Timezone              string        `mapstructure:"TZ"`
		GracefullyDuration    time.Duration `mapstructure:"GRACEFULL_DURATION"`
		LogDirectory          string        `mapstructure:"LOG_DIRECTORY"`
		ElasticAPMServiceName string        `mapstructure:"ELASTIC_APM_SERVICE_NAME"`
		LogLevel              string        `mapstructure:"LOG_LEVEL"`
	}
)

func NewAppConfig() (AppConfig, error) {
	config := AppConfig{}

	if err := NewFromENV(&config); err != nil {
		return AppConfig{}, err
	}

	return config, nil
}
