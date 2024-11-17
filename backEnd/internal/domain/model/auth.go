package model

import obModel "backEnd/internal/outbound/model"

type (
	LoginRequest struct {
		Username string
		Password string
	}

	RegisterRequest struct {
		Username string
		Password string
		Email    string
	}
)

func (c RegisterRequest) ToObModel() obModel.RequestRegister {
	return obModel.RequestRegister{
		Username: c.Username,
		Password: c.Password,
		Email:    c.Email,
		Coin:     0,
		Balance:  0,
		Pin:      "000000",
	}
}
