package model

type BalanceCategory struct {
	ID       int64 `gorm:"column:id"`
	Category string `gorm:"column:category"`
}
