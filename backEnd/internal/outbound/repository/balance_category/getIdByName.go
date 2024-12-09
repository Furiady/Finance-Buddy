package balance_category

import (
	"backEnd/internal/outbound/model"
	"context"
	"strconv"
)

// GetIdByName checks if a category exists in balance_category table.
func (r *repository) GetIdByName(ctx context.Context, category string) (*string, error) {
	db := r.resource.DatabaseSQL.DB
	balanceCategory := model.BalanceCategory{
		Category: category,
	}

	err := db.WithContext(ctx).
		Where("category = ?", category).
		FirstOrCreate(&balanceCategory).Error
	if err != nil {
		return nil, err
	}

	categoryIdStr := strconv.Itoa(int(balanceCategory.ID))
	return &categoryIdStr, nil
}
