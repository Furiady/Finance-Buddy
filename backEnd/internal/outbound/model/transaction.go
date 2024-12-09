package model

import (
	"time"
)

type (
	Transaction struct {
		Id          string    `gorm:"column:id"`
		Title       string    `gorm:"column:title"`
		Description string    `gorm:"column:description"`
		Type        string    `gorm:"column:type"`
		Category    string    `gorm:"column:category"`
		Value       int64     `gorm:"column:value"`
		Url         string    `gorm:"column:url"`
		CreatedAt   time.Time `gorm:"column:created_at"`
		DeletedAt   time.Time `gorm:"index"`
	}
	Transactions []Transaction

	RequestCreateTransaction struct {
		UserId      string    `gorm:"column:user_id"`
		Title       string    `gorm:"column:title"`
		Description string    `gorm:"column:description"`
		Category    string    `gorm:"column:category"`
		Value       int64     `gorm:"column:value"`
		CreatedAt   time.Time `gorm:"column:created_at"`
		Type        string    `gorm:"column:type"`
	}

	RequestUpdateTransaction struct {
		Id          string    `gorm:"column:id"`
		UserId      string    `gorm:"column:user_id"`
		Title       string    `gorm:"column:title"`
		Description string    `gorm:"column:description"`
		Category    string    `gorm:"column:category"`
		Value       int64     `gorm:"column:value"`
		CreatedAt   time.Time `gorm:"column:created_at"`
		Type        string    `gorm:"column:type"`
	}

	RequestDeleteTransaction struct {
		UserId        string
		TransactionId string
	}

	RequestFindTransaction struct {
		UserId        string
		TransactionId string
	}
)

func (Transaction) TableName() string {
	return "transactions"
}
