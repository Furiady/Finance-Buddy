package user_quest

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, userId string, questId string) (model.UserQuest, error) {
	db := r.resource.DatabaseSQL.DB
	var result model.UserQuest

	err := db.Table(result.TableName()).
		Where("user_id = ?", userId).
		Where("quest_id = ?", questId).
		Find(&result).Error
	if err != nil {
		return model.UserQuest{}, err
	}

	return result, nil
}
