package model

type (
	Theme struct {
		Id     int    `gorm:"column:id"`
		Name   string `gorm:"column:name"`
		Price  int    `gorm:"column:price"`
		Url    string `gorm:"column:url"`
		Status bool   `gorm:"column:status"`
	}
	Themes []Theme
)

func (Theme) TableName() string {
	return "themes"
}
