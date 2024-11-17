package theme

import "context"

// UpdateStatusOwned implements Repository.
func (r *repository) UpdateStatusOwned(ctx context.Context, userId string, themeId string) error {
	var (
		db = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table("user_theme").
		Create(map[string]interface{}{
			"user_id":  userId,
			"theme_id": themeId,
			"status":   true,
		}).Error
	if err != nil {
		return err
	}

	return nil
}
