package user

import (
	"backEnd/internal/outbound/model"
	"context"
)

// UpdateCoin implements Repository.
func (r *repository) UpdateCoin(ctx context.Context, userId string, coin int) error {
	db := r.resource.DatabaseSQL.DB

	err := db.WithContext(ctx).
		Table(model.User{}.TableName()).
		Where("id = ?", userId).
		Update("coin", coin).Error
	if err != nil {
		return err
	}

	return nil
}
