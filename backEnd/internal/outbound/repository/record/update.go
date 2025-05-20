package record

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Update implements Repository.
func (r *repository) Update(ctx context.Context, request model.RequestUpdateRecord) error {
	db := r.resource.DatabaseSQL.DB

	err := db.WithContext(ctx).
		Table(model.Record{}.TableName()).
		Where("user_id = ? AND id = ?", request.UserId, request.Id).
		Updates(request).Error
	if err != nil {
		return err
	}

	return nil
}
