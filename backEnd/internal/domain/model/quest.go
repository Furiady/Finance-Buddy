package model

import (
	obModel "backEnd/internal/outbound/model"
)

type (
	Quest struct {
		Id          string
		Title       string
		Description string
		Reward      int
		Cooldown    int
		Status      bool
		Count       int
		Limit       int
		UpdatedAt   string
	}
	Quests []Quest
)

func (q Quests) FromObModel(data obModel.Quests) Quests {
	quests := Quests{}
	for _, quest := range data {
		quests = append(quests, Quest{}.FromObModel(quest))
	}
	return quests
}

func (q Quest) FromObModel(data obModel.Quest) Quest {
	return Quest{
		Id:          data.Id,
		Title:       data.Title,
		Description: data.Description,
		Reward:      data.Reward,
		Cooldown:    data.Cooldown,
		Status:      data.Status,
		Count:       data.Count,
		Limit:       data.Limit,
		UpdatedAt:   data.UpdatedAt,
	}
}
