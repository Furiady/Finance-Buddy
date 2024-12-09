package transaction

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Create implements Repository.
func (r *repository) Create(ctx context.Context, request model.RequestCreateTransaction) error {
	db := r.resource.DatabaseSQL.DB

	err := db.WithContext(ctx).
		Table(model.Transaction{}.TableName()).
		Create(request).Error
	if err != nil {
		return err
	}

	return nil
}
