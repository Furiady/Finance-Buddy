package model

import obModel "backEnd/internal/outbound/model"

type (
	Accessory struct {
		Id     int
		Name   string
		Price  int
		Path   string
		Status bool
	}

	Accessories []Accessory
)

func (t Accessories) FromObModel(datas obModel.Accessories) Accessories {
	var result Accessories
	for _, data := range datas {
		result = append(result, Accessory{}.FromObModel(data))
	}

	return result
}

func (t Accessory) FromObModel(data obModel.Accessory) Accessory {
	return Accessory{
		Id:     data.Id,
		Name:   data.Name,
		Price:  data.Price,
		Path:   data.Path,
		Status: data.Status,
	}
}
