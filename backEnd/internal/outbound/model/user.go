package model

type (
	User struct {
		Id           int    `gorm:"column:id"`
		Username     string `gorm:"column:username"`
		Email        string `gorm:"column:email"`
		Password     string `gorm:"column:password"`
		Pin          string `gorm:"column:pin"`
		Coin         int    `gorm:"column:coin"`
		Gamification string  `gorm:"column:gamification"`
	}

	RequestGetUser struct {
		UserId   *string
		Username *string
		Email    *string
	}

	RequestRegister struct {
		Username string `gorm:"column:username"`
		Email    string `gorm:"column:email"`
		Password string `gorm:"column:password"`
		Pin      string `gorm:"column:pin"`
		Coin     int    `gorm:"column:coin"`
	}

	UserAsset struct {
		UserId     int           `gorm:"column:user_id"`
		CategoryId int           `gorm:"column:category_id"`
		Category   AssetCategory `gorm:"foreignKey:CategoryId;references:ID"`
		Value      int64         `gorm:"column:value"`
	}
	UserAssets []UserAsset

	RequestGetUserAsset struct {
		UserId     string
		CategoryId string
	}

	RequestSaveUserAsset struct {
		UserId     string `gorm:"column:user_id;primaryKey"`
		CategoryId string `gorm:"column:category_id;primaryKey"`
		Value      int64  `gorm:"column:value"`
	}

	RequestGetUserAssets struct {
		UserId string
	}
)

func (User) TableName() string {
	return "users"
}

func (UserAsset) TableName() string {
	return "user_asset"
}
