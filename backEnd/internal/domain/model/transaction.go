package model

import (
	obModel "backEnd/internal/outbound/model"
	"time"
)

type (
	Transaction struct {
		Id          string
		Title       string
		Description string
		Type        string
		Category    string
		Value       int64
		CreatedAt   string
		Url         string
	}
	Transactions []Transaction

	RequestCreateTransaction struct {
		Title       string
		Description string
		Type        string
		Category    string
		Value       int64
		CreatedAt   string
	}

	RequestUpdateTransaction struct {
		Id          string
		Title       string
		Description string
		Type        string
		Category    string
		Value       int64
		CreatedAt   string
	}
)

func (t Transaction) FromObModel(data obModel.Transaction) Transaction {
	return Transaction{
		Id:          data.Id,
		Title:       data.Title,
		Description: data.Description,
		Type:        data.Type,
		Category:    data.Category,
		Value:       data.Value,
		CreatedAt:   data.CreatedAt.Format("20060102"),
		Url:         data.Url,
	}
}

func (r RequestCreateTransaction) ToObModel(userId string) obModel.RequestCreateTransaction {
	parsedDate, _ := time.Parse("20060102", r.CreatedAt)

	return obModel.RequestCreateTransaction{
		Title:       r.Title,
		Description: r.Description,
		Category:    r.Category,
		Value:       r.Value,
		CreatedAt:   parsedDate,
		UserId:      userId,
		Type:        r.Type,
	}
}

func (r RequestUpdateTransaction) ToObModel(userId string) obModel.RequestUpdateTransaction {
	parsedDate, _ := time.Parse("20060102", r.CreatedAt)

	return obModel.RequestUpdateTransaction{
		Id:          r.Id,
		Title:       r.Title,
		Description: r.Description,
		Category:    r.Category,
		Value:       r.Value,
		CreatedAt:   parsedDate,
		UserId:      userId,
		Type:        r.Type,
	}
}
