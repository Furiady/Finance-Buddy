package record

import (
	"backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// GetRecordsByCategory implements StrictServerInterface.
func (c *Controller) GetRecordsByCategory(ctx context.Context, request GetRecordsByCategoryRequestObject) (GetRecordsByCategoryResponseObject, error) {
	data, err := c.Domain.UseCases.Record.GetTotalByCategory(ctx, model.RequestGetTotalByCategory{
		StartDate: request.Params.StartDate,
		EndDate:   request.Params.EndDate,
		Type:      *request.Params.Type,
	})
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetRecordsByCategorydefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	result := []RecordCount{}
	for category, value := range data {
		if value < 0 {
			value *= -1
		}
		result = append(result, RecordCount{
			Category: category,
			Value:    value,
		})
	}

	return GetRecordsByCategory200JSONResponse(result), nil
}
