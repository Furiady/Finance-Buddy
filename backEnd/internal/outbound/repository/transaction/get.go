package transaction

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, request model.RequestFindTransaction) (model.Transaction, error) {
	db := r.resource.DatabaseSQL.DB
	var result model.Transaction

	err := db.WithContext(ctx).
		Table(model.Transaction{}.TableName()).
		Where("user_id = ? AND id = ? AND deleted_at IS NULL", request.UserId, request.TransactionId).
		Find(&result).Error
	if err != nil {
		return model.Transaction{}, err
	}

	return result, nil
}
