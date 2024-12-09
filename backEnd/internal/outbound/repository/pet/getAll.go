package pet

import (
	"backEnd/internal/outbound/model"
	"context"
)

// GetAll implements Repository.
func (r *repository) GetAll(ctx context.Context, userId string) (model.Pets, error) {
	var (
		result model.Pets
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table(model.Pet{}.TableName()).
		Select("pets.*, user_pet.status").
		Joins("LEFT JOIN user_pet ON user_pet.pet_id = pets.id AND user_pet.user_id = ?", userId).
		Find(&result).Error
	if err != nil {
		return model.Pets{}, err
	}

	return result, nil
}
