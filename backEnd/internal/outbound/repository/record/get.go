package record

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, request model.RequestFindRecord) (model.Record, error) {
	db := r.resource.DatabaseSQL.DB
	var result model.Record

	err := db.WithContext(ctx).
		Table(model.Record{}.TableName()).
		Where("user_id = ? AND id = ? AND deleted_at IS NULL", request.UserId, request.RecordId).
		Find(&result).Error
	if err != nil {
		return model.Record{}, err
	}

	return result, nil
}
