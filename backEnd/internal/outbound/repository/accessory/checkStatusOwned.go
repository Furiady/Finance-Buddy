package accessory

import (
	"context"

	"github.com/pkg/errors"
)

// CheckStatusOwned implements Repository.
func (r *repository) CheckStatusOwned(ctx context.Context, userId string, accessoryId string) error {
	var (
		result int64
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table("user_accessory").
		Where("user_id = ? AND accessory_id = ?", userId, accessoryId).
		Count(&result).Error
	if err != nil {
		return err
	}

	if result > 0 {
		return errors.New("accessory already owned")
	}

	return nil
}
