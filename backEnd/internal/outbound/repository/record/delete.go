package record

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Delete implements Repository.
func (r *repository) Delete(ctx context.Context, request model.RequestDeleteRecord) error {
	db := r.resource.DatabaseSQL.DB

	err := db.WithContext(ctx).
		Table(model.Record{}.TableName()).
		Where("user_id = ?", request.UserId).
		Where("id = ?", request.RecordId).
		Delete(&model.Record{}).Error
	if err != nil {
		return err
	}

	return nil
}
