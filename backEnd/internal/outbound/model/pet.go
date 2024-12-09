package model

type (
	Pet struct {
		Id     int    `gorm:"column:id"`
		Name   string `gorm:"column:name"`
		Price  int    `gorm:"column:price"`
		Path   string `gorm:"column:path"`
		Status bool   `gorm:"column:status"`
	}
	Pets []Pet
)

func (Pet) TableName() string {
	return "pets"
}
