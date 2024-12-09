package accessory

import "context"

// UpdateStatusOwned implements Repository.
func (r *repository) UpdateStatusOwned(ctx context.Context, userId string, accessoryId string) error {
	var (
		db = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table("user_accessory").
		Create(map[string]interface{}{
			"user_id":  userId,
			"accessory_id": accessoryId,
			"status":   true,
		}).Error
	if err != nil {
		return err
	}

	return nil
}
