package model

type (
	Accessory struct {
		Id     int    `gorm:"column:id"`
		Name   string `gorm:"column:name"`
		Price  int    `gorm:"column:price"`
		Path   string `gorm:"column:path"`
		Status bool   `gorm:"column:status"`
	}
	Accessories []Accessory
)

func (Accessory) TableName() string {
	return "accessories"
}
