package user_asset

import (
	"backEnd/internal/outbound/model"
	"context"
)

// GetAll implements Repository.
func (r *repository) GetAll(ctx context.Context, request model.RequestGetUserAssets) (model.UserAssets, error) {
	var (
		result model.UserAssets
		db     = r.resource.DatabaseSQL.DB

		query = db.WithContext(ctx).
			Model(result).
			Preload("Category").
			Where("user_id = ?", request.UserId)
	)

	err := query.Find(&result).Error
	if err != nil {
		return model.UserAssets{}, err
	}

	return result, nil
}
