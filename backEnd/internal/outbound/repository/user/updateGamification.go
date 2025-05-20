package user

import (
	"backEnd/internal/outbound/model"
	"context"
)

// UpdateGamification implements Repository.
func (r *repository) UpdateGamification(ctx context.Context, userId string, gamification string) error {
	db := r.resource.DatabaseSQL.DB

	err := db.WithContext(ctx).
		Table(model.User{}.TableName()).
		Where("id = ?", userId).
		Update("gamification", gamification).Error
	if err != nil {
		return err
	}

	return nil
}
