package asset_category

import (
	"backEnd/internal/outbound/model"
	"context"
	"strconv"
)

// GetIdByName checks if a category exists in asset_category table.
func (r *repository) GetIdByName(ctx context.Context, category string) (*string, error) {
	db := r.resource.DatabaseSQL.DB
	assetCategory := model.AssetCategory{
		Category: category,
	}

	err := db.WithContext(ctx).
		Where("category = ?", category).
		FirstOrCreate(&assetCategory).Error
	if err != nil {
		return nil, err
	}

	categoryIdStr := strconv.Itoa(int(assetCategory.ID))
	return &categoryIdStr, nil
}
