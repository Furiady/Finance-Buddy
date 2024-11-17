package model

type (
	User struct {
		Id       int    `gorm:"column:id"`
		Username string `gorm:"column:username"`
		Email    string `gorm:"column:email"`
		Password string `gorm:"column:password"`
		Pin      string `gorm:"column:pin"`
		Coin     int    `gorm:"column:coin"`
		Balance  int    `gorm:"column:balance"`
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
		Balance  int    `gorm:"column:balance"`
	}
)

func (User) TableName() string {
	return "users"
}
