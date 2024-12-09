package pet

import (
	"context"

	"github.com/pkg/errors"
)

// CheckStatusOwned implements Repository.
func (r *repository) CheckStatusOwned(ctx context.Context, userId string, petId string) error {
	var (
		result int64
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table("user_pet").
		Where("user_id = ? AND pet_id = ?", userId, petId).
		Count(&result).Error
	if err != nil {
		return err
	}

	if result > 0 {
		return errors.New("pet already owned")
	}

	return nil
}
