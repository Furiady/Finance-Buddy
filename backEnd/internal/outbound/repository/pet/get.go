package pet

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, petId string) (model.Pet, error) {
	var (
		result model.Pet
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
        Table(model.Pet{}.TableName()).
		Select("pets.*").
		Where("pets.id = ?", petId).
        Find(&result).Error
	if err != nil {
		return model.Pet{}, err
	}

	return result, nil
}