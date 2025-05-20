package quest

import (
	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// GetQuests implements StrictServerInterface.
func (c *Controller) GetQuests(ctx context.Context, request GetQuestsRequestObject) (GetQuestsResponseObject, error) {
	data, err := c.Domain.UseCases.Quest.GetAll(ctx)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetQuestsdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return GetQuests200JSONResponse(fromUcModelQuests(data)), nil
}

func fromUcModelQuests(data ucModel.Quests) []Quest {
	var quests []Quest
	for _, quest := range data {
		quests = append(quests, fromUcModelQuest(quest))
	}
	return quests
}

func fromUcModelQuest(data ucModel.Quest) Quest {
	return Quest{
		Id:          data.Id,
		Cooldown:    data.Cooldown,
		Count:       data.Count,
		Description: data.Description,
		Limit:       data.Limit,
		Reward:      data.Reward,
		Status:      data.Status,
		Title:       data.Title,
	}
}
