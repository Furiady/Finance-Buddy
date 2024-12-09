package pet

import "context"

// UpdateStatusOwned implements Repository.
func (r *repository) UpdateStatusOwned(ctx context.Context, userId string, petId string) error {
	var (
		db = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table("user_pet").
		Create(map[string]interface{}{
			"user_id": userId,
			"pet_id":  petId,
			"status":  true,
		}).Error
	if err != nil {
		return err
	}

	return nil
}
