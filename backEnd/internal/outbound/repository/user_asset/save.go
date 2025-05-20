package user_asset

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Save implements Repository.
func (r *repository) Save(ctx context.Context, request model.RequestSaveUserAsset) error {
	var (
		db = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).Table(model.UserAsset{}.TableName()).Save(request).Error
	if err != nil {
		return err
	}

	return nil
}
