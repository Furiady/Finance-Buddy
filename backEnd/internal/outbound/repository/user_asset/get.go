package user_asset

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, request model.RequestGetUserAsset) (model.UserAsset, error) {
	var (
		result model.UserAsset
		db     = r.resource.DatabaseSQL.DB

		query = db.WithContext(ctx).
			Model(result).
			Preload("Category").
			Where("user_id = ?", request.UserId).
			Where("category_id = ?", request.CategoryId)
	)

	err := query.Find(&result).Error
	if err != nil {
		return model.UserAsset{}, err
	}

	return result, nil
}
