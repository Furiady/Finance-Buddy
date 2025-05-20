package user_quest

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Update implements Repository.
func (r *repository) Update(ctx context.Context, request model.UserQuest) error {
	db := r.resource.DatabaseSQL.DB

	err := db.Table(request.TableName()).
		Where("user_id = ?", request.UserId).
		Where("quest_id = ?", request.QuestId).
		Save(&request).Error
	if err != nil {
		return err
	}

	return nil
}
