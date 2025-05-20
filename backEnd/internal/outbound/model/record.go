package model

import (
	"time"
)

type (
	Record struct {
		Id          string    `gorm:"column:id"`
		Title       string    `gorm:"column:title"`
		Description string    `gorm:"column:description"`
		Type        string    `gorm:"column:type"`
		Category    string    `gorm:"column:category"`
		Value       int64     `gorm:"column:value"`
		Url         *string   `gorm:"column:url"`
		DeductFrom  *string   `gorm:"column:deduct_from"`
		CreatedAt   time.Time `gorm:"column:created_at"`
		DeletedAt   time.Time `gorm:"index"`
	}
	Records []Record

	RequestCreateRecord struct {
		UserId      string    `gorm:"column:user_id"`
		Title       string    `gorm:"column:title"`
		Description *string   `gorm:"column:description"`
		Category    string    `gorm:"column:category"`
		Value       int64     `gorm:"column:value"`
		CreatedAt   time.Time `gorm:"column:created_at"`
		Type        string    `gorm:"column:type"`
		DeductFrom  *string   `gorm:"column:deduct_from"`
		Url         *string   `gorm:"column:url"`
	}

	RequestUpdateRecord struct {
		Id          string    `gorm:"column:id"`
		UserId      string    `gorm:"column:user_id"`
		Title       string    `gorm:"column:title"`
		Description *string   `gorm:"column:description"`
		Category    string    `gorm:"column:category"`
		Value       int64     `gorm:"column:value"`
		CreatedAt   time.Time `gorm:"column:created_at"`
		Type        string    `gorm:"column:type"`
		DeductFrom  *string   `gorm:"column:deduct_from"`
		Url         *string   `gorm:"column:url"`
	}

	RequestDeleteRecord struct {
		UserId   string
		RecordId string
	}

	RequestFindRecord struct {
		UserId   string
		RecordId string
	}

	RequestGetAllRecord struct {
		UserId     string
		StartDate  string
		EndDate    string
		RecordType *string
		Category   *string
		DeductFrom *string
		Limit      *int
		Page       *int
	}

	RequestCount struct {
		UserId     string
		StartDate  string
		EndDate    string
	}

	RequestGetTotalByType struct {
		UserId    string
		StartDate string
		EndDate   string
	}
)

func (Record) TableName() string {
	return "records"
}
