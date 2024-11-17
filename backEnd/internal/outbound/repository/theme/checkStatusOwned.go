package theme

import (
	"context"

	"github.com/pkg/errors"
)

// CheckStatusOwned implements Repository.
func (r *repository) CheckStatusOwned(ctx context.Context, userId string, themeId string) error {
	var (
		result int64
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table("user_theme").
		Where("user_id = ? AND theme_id = ?", userId, themeId).
		Count(&result).Error
	if err != nil {
		return err
	}

	if result > 0 {
		return errors.New("theme already owned")
	}

	return nil
}
