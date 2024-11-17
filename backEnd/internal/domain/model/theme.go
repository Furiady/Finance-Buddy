package model

import obModel "backEnd/internal/outbound/model"

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

func (t Themes) FromObModel(datas obModel.Themes) Themes {
	var result Themes
	for _, data := range datas {
		result = append(result, Theme{}.FromObModel(data))
	}

	return result
}

func (t Theme) FromObModel(data obModel.Theme) Theme {
	return Theme{
		Id:     data.Id,
		Name:   data.Name,
		Price:  data.Price,
		Url:    data.Url,
		Status: data.Status,
	}
}
