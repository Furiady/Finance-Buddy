package model

import obModel "backEnd/internal/outbound/model"

type (
	User struct {
		Id       int
		Username string
		Email    string
		Pin      string
		Coin     int
		Balance  int64
	}
)

func (u User) FromObModel(data obModel.User) User {
	return User{
		Id:       data.Id,
		Username: data.Username,
		Email:    data.Email,
		Pin:      data.Pin,
		Coin:     data.Coin,
		Balance:  data.Balance,
	}
}
