package record

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get All implements Repository.
func (r *repository) GetAll(ctx context.Context, request model.RequestGetAllRecord) (model.Records, error) {
	var (
		db     = r.resource.DatabaseSQL.DB
		result = model.Records{}
		q      = db.WithContext(ctx).
			Table(model.Record{}.TableName()).
			Where("user_id = ? AND deleted_at IS NULL", request.UserId).
			Where("created_at BETWEEN ? AND ?", request.StartDate, request.EndDate)
	)

	if request.RecordType != nil && request.Category != nil && request.DeductFrom != nil {
		q = q.Where("(type = ? AND category = ?) OR deduct_from = ?", request.RecordType, request.Category, request.DeductFrom)
	} else {
		if request.RecordType != nil {
			q = q.Where("type = ?", request.RecordType)
		}
		if request.Category != nil {
			q = q.Where("category = ?", request.Category)
		}
	}

	if request.Limit != nil && request.Page != nil {
		q = q.Limit(*request.Limit).Offset((*request.Page - 1) * (*request.Limit))
	}

	err := q.Order("id DESC").
		Find(&result).Error
	if err != nil {
		return model.Records{}, err
	}

	return result, nil
}
