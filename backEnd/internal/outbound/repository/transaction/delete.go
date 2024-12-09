package transaction

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Delete implements Repository.
func (r *repository) Delete(ctx context.Context, request model.RequestDeleteTransaction) error {
	db := r.resource.DatabaseSQL.DB

	err := db.WithContext(ctx).
		Table(model.Transaction{}.TableName()).
		Where("user_id = ?", request.UserId).
		Where("id = ?", request.TransactionId).
		Delete(&model.Transaction{}).Error
	if err != nil {
		return err
	}

	return nil
}
