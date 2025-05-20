package quest

import (
	"backEnd/internal/outbound/model"
	"context"
)

// GetAll implements Repository.
func (r *repository) GetAll(ctx context.Context, userId string) (model.Quests, error) {
	var (
		result model.Quests
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table(model.Quest{}.TableName()).
		Select("quests.*, user_quest.status, user_quest.count, user_quest.updated_at").
		Joins("LEFT JOIN user_quest ON user_quest.quest_id = quests.id AND user_quest.user_id = ?", userId).
		Find(&result).Error
	if err != nil {
		return model.Quests{}, err
	}

	return result, nil
}
