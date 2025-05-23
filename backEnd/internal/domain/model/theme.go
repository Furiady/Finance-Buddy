package model

import obModel "backEnd/internal/outbound/model"

type (
	Theme struct {
		Id     int
		Name   string
		Price  int
		Path   string
		Status bool
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
		Path:   data.Path,
		Status: data.Status,
	}
}
