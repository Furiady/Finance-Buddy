package record

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Count implements Repository.
func (r *repository) Count(ctx context.Context, request model.RequestCount) (int64, error) {
	var (
		db     = r.resource.DatabaseSQL.DB
		result int64
		q      = db.WithContext(ctx).
			Table(model.Record{}.TableName()).
			Where("user_id = ? AND deleted_at IS NULL", request.UserId).
			Where("created_at BETWEEN ? AND ?", request.StartDate, request.EndDate)
	)

	err := q.Count(&result).Error
	if err != nil {
		return 0, err
	}

	return result, nil
}
