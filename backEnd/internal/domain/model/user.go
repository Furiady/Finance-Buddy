package model

import obModel "backEnd/internal/outbound/model"

type (
	User struct {
		Id           int
		Username     string
		Email        string
		Pin          string
		Coin         int
		Gamification string
	}

	UserAsset struct {
		Category string
		Value    int64
	}
	UserAssets []UserAsset

	UserLiability struct {
		Category string
		Value    int64
	}
	UserLiabilities []UserLiability
)

func (u User) FromObModel(data obModel.User) User {
	return User{
		Id:           data.Id,
		Username:     data.Username,
		Email:        data.Email,
		Pin:          data.Pin,
		Coin:         data.Coin,
		Gamification: data.Gamification,
	}
}

func (u UserAsset) FromObModel(data obModel.UserAsset) UserAsset {
	return UserAsset{
		Category: data.Category.Category,
		Value:    data.Value,
	}
}

func (u UserAssets) FromObModel(data obModel.UserAssets) UserAssets {
	var userAssets UserAssets
	for _, v := range data {
		if v.Value > 0 {
			userAssets = append(userAssets, UserAsset{
				Category: v.Category.Category,
				Value:    v.Value,
			})
		}
	}
	return userAssets
}

func (u UserLiability) FromObModel(data obModel.UserAsset) UserLiability {
	return UserLiability{
		Category: data.Category.Category,
		Value:    data.Value,
	}
}

func (u UserLiabilities) FromObModel(data obModel.UserAssets) UserLiabilities {
	var userLiabilities UserLiabilities
	for _, v := range data {
		if v.Value < 0 {
			userLiabilities = append(userLiabilities, UserLiability{
				Category: v.Category.Category,
				Value:    v.Value,
			})
		}
	}
	return userLiabilities
}
