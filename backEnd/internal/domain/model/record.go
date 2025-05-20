package model

import (
	obModel "backEnd/internal/outbound/model"
	"fmt"
	"mime/multipart"
	"time"
)

type (
	Record struct {
		Id          string
		Title       string
		Description string
		Type        string
		Category    string
		Value       int64
		CreatedAt   string
		DeductFrom  *string
		Url         *string
	}
	Records []Record

	RequestCreateRecord struct {
		Title       string
		Description *string
		Type        string
		Category    string
		Value       int64
		DeductFrom  *string
		CreatedAt   string
		Image       *multipart.FileHeader
	}

	RequestUpdateRecord struct {
		Id          string
		Title       string
		Description *string
		Type        string
		Category    string
		Value       int64
		DeductFrom  *string
		CreatedAt   string
		Image       *multipart.FileHeader
	}

	RequestGetAllRecord struct {
		StartDate  string
		EndDate    string
		RecordType *string
		Category   *string
		DeductFrom *string
		Limit      *int
		Page       *int
	}

	RequestGetTotalByCategory struct {
		StartDate string
		EndDate   string
		Type      string
	}

	RequestGetTotalByType struct {
		StartDate string
		EndDate   string
	}
)

func (t Record) FromObModel(data obModel.Record) Record {
	return Record{
		Id:          data.Id,
		Title:       data.Title,
		Description: data.Description,
		Type:        data.Type,
		Category:    data.Category,
		Value:       data.Value,
		CreatedAt:   data.CreatedAt.Format("20060102"),
		DeductFrom:  data.DeductFrom,
		Url:         data.Url,
	}
}

func (r Records) FromObModel(data obModel.Records) Records {
	records := Records{}
	for _, record := range data {
		records = append(records, Record{}.FromObModel(record))
	}
	return records
}

func (r RequestCreateRecord) ToObModel(userId string, url *string) obModel.RequestCreateRecord {
	parsedDate, _ := time.Parse("20060102", r.CreatedAt)

	return obModel.RequestCreateRecord{
		Title:       r.Title,
		Description: r.Description,
		Category:    r.Category,
		Value:       r.Value,
		CreatedAt:   parsedDate,
		UserId:      userId,
		Type:        r.Type,
		DeductFrom:  r.DeductFrom,
		Url:         url,
	}
}

func (r RequestUpdateRecord) ToObModel(userId string, url *string) obModel.RequestUpdateRecord {
	parsedDate, _ := time.Parse("20060102", r.CreatedAt)

	return obModel.RequestUpdateRecord{
		Id:          r.Id,
		Title:       r.Title,
		Description: r.Description,
		Category:    r.Category,
		Value:       r.Value,
		CreatedAt:   parsedDate,
		UserId:      userId,
		Type:        r.Type,
		DeductFrom:  r.DeductFrom,
		Url:         url,
	}
}

func (r RequestGetAllRecord) ToObModel(userId string) obModel.RequestGetAllRecord {
	return obModel.RequestGetAllRecord{
		UserId:     userId,
		StartDate:  fmt.Sprintf(r.StartDate + " 06:59:59.000 +0700"),
		EndDate:    fmt.Sprintf(r.EndDate + " 23:59:59"),
		RecordType: r.RecordType,
		Category:   r.Category,
		DeductFrom: r.DeductFrom,
		Limit:      r.Limit,
		Page:       r.Page,
	}
}

func (r RequestGetTotalByCategory) ToObModel(userId string) obModel.RequestGetAllRecord {
	return obModel.RequestGetAllRecord{
		UserId:     userId,
		StartDate:  fmt.Sprintf(r.StartDate + " 06:59:59.000 +0700"),
		EndDate:    fmt.Sprintf(r.EndDate + " 23:59:59"),
		RecordType: &r.Type,
	}
}

func (r RequestGetTotalByType) ToObModel(userId string) obModel.RequestGetTotalByType {
	return obModel.RequestGetTotalByType{
		UserId:    userId,
		StartDate:  fmt.Sprintf(r.StartDate + " 06:59:59.000 +0700"),
		EndDate:    fmt.Sprintf(r.EndDate + " 23:59:59"),
	}
}
