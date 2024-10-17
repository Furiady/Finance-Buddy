package config

import (
	"fmt"
	"os"
	"strings"

	"github.com/spf13/viper"
)

func NewFromENV(configuration interface{}) error {
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

	if err := NewFromEnv(filePath, &configuration); err != nil {
		return fmt.Errorf("%s failed to read from env variable", err)
	}

	return nil
}

func New(path string, configType string, object interface{}) error {
	// - check file does exists
	if _, err := os.Stat(path); os.IsNotExist(err) {
		return fmt.Errorf("config file %s does not exists\nerror: %+v", path, err)
	}

	dir := getDirectory(path)
	file, err := getFile(path)

	if err != nil {
		return err
	}

	v := viper.New()
	v.SetConfigName(file)
	v.AddConfigPath(dir)
	v.SetConfigType(configType)
	v.AutomaticEnv()

	if err := v.ReadInConfig(); err != nil {
		return fmt.Errorf("failed to read %s file\nerror: %+v", path, err)
	}

	if err := v.Unmarshal(object); err != nil {
		return fmt.Errorf("failed to unmarshal config to object\nerror: %+v", err)
	}

	return nil
}

func NewFromEnv(path *string, object interface{}) error {
	v := viper.New()
	if path == nil {
		bindEnvs(v)
		v.AutomaticEnv()
	} else {
		v.SetConfigType("env")
		v.SetConfigFile(*path)

		if err := v.ReadInConfig(); err != nil {
			return fmt.Errorf("failed to read %s file\nerror: %+v", *path, err)
		}
	}
	if err := v.Unmarshal(object); err != nil {
		return fmt.Errorf("failed to unmarshal config to object\nerror:%+v", err)
	}

	return nil
}

func getDirectory(path string) string {
	splits := strings.Split(path, "/")
	return strings.Join(splits[:len(splits)-1], "/")
}

func getFile(path string) (string, error) {
	splits := strings.Split(path, "/")
	last := splits[len(splits)-1]

	return last, nil
}

func bindEnvs(v *viper.Viper) error {
	var pair []string
	for _, env := range os.Environ() {
		pair = strings.Split(env, "=")
		if len(pair) == 2 {
			v.SetDefault(pair[0], pair[1])
		}
	}
	return nil
}
