package quest

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, userId string) (model.Quest, error) {
	var (
		result model.Quest
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table(model.Quest{}.TableName()).
		Select("quests.*, user_quest.status, user_quest.count, user_quest.updated_at").
		Joins("LEFT JOIN user_quest ON user_quest.quest_id = quests.id AND user_quest.user_id = ?", userId).
		Find(&result).Error
	if err != nil {
		return model.Quest{}, err
	}

	return result, nil
}
