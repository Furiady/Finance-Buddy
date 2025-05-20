package model

type AssetCategory struct {
	ID       int64  `gorm:"column:id"`
	Category string `gorm:"column:category"`
}
