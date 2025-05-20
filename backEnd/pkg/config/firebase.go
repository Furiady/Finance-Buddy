package config

type (
	FirebaseConfig struct {
		BucketName string `mapstructure:"FIREBASE_BUCKET_NAME"`
		ProjectId  string `mapstructure:"FIREBASE_PROJECT_ID"`
	}
)

func NewFirebaseConfig() (FirebaseConfig, error) {
	config := FirebaseConfig{}

	if err := NewFromENV(&config); err != nil {
		return FirebaseConfig{}, err
	}

	return config, nil
}
