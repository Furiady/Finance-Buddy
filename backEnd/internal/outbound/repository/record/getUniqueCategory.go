package record

import (
	"backEnd/internal/outbound/model"
	"context"
)

func (r *repository) GetUniqueCategories(ctx context.Context, userId string) ([]string, error) {
	db := r.resource.DatabaseSQL.DB
	var categories []string

	err := db.WithContext(ctx).
		Table(model.Record{}.TableName()).
		Where("user_id = ?", userId).
		Distinct("category").
		Pluck("category", &categories).Error
	if err != nil {
		return nil, err
	}

	return categories, nil
}
