package record

import (
	"backEnd/internal/outbound/model"
	"context"
)

// GetTotalByType implements Repository.
func (r *repository) GetTotalByType(ctx context.Context, request model.RequestGetTotalByType) (map[string]int64, error) {
	var (
        db     = r.resource.DatabaseSQL.DB
        result = make(map[string]int64)
        q      = db.WithContext(ctx).
            Table(model.Record{}.TableName()).
            Select("type, SUM(value) as total").
            Where("user_id = ? AND deleted_at IS NULL", request.UserId).
            Where("created_at BETWEEN ? AND ?", request.StartDate, request.EndDate).
            Group("type")
    )

    rows, err := q.Rows()
    if err != nil {
        return nil, err
    }
    defer rows.Close()

    for rows.Next() {
        var recordType string
        var total int64
        if err := rows.Scan(&recordType, &total); err != nil {
            return nil, err
        }
        result[recordType] = total
    }

    return result, nil
}
