package accessory

import (
	"backEnd/internal/outbound/model"
	"context"
)

// GetAll implements Repository.
func (r *repository) GetAll(ctx context.Context, userId string) (model.Accessories, error) {
	var (
		result model.Accessories
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table(model.Accessory{}.TableName()).
		Select("accessories.*, user_accessory.status").
		Joins("LEFT JOIN user_accessory ON user_accessory.accessory_id = accessories.id AND user_accessory.user_id = ?", userId).
		Find(&result).Error
	if err != nil {
		return model.Accessories{}, err
	}

	return result, nil
}
