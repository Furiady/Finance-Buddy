package accessory

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, accessoryId string) (model.Accessory, error) {
	var (
		result model.Accessory
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
        Table(model.Accessory{}.TableName()).
		Select("accessories.*").
		Where("accessories.id = ?", accessoryId).
        Find(&result).Error
	if err != nil {
		return model.Accessory{}, err
	}

	return result, nil
}