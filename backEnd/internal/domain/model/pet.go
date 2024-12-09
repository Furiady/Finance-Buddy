package model

import obModel "backEnd/internal/outbound/model"

type (
	Pet struct {
		Id     int
		Name   string
		Price  int
		Path   string
		Status bool
	}

	Pets []Pet
)

func (t Pets) FromObModel(datas obModel.Pets) Pets {
	var result Pets
	for _, data := range datas {
		result = append(result, Pet{}.FromObModel(data))
	}

	return result
}

func (t Pet) FromObModel(data obModel.Pet) Pet {
	return Pet{
		Id:     data.Id,
		Name:   data.Name,
		Price:  data.Price,
		Path:   data.Path,
		Status: data.Status,
	}
}
