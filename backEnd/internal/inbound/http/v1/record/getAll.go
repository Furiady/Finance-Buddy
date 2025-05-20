package record

import (
	"backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// GetRecords implements StrictServerInterface.
func (c *Controller) GetRecords(ctx context.Context, request GetRecordsRequestObject) (GetRecordsResponseObject, error) {
	data, err := c.Domain.UseCases.Record.GetAll(ctx, model.RequestGetAllRecord{
		StartDate:  request.Params.StartDate,
		EndDate:    request.Params.EndDate,
		RecordType: request.Params.Type,
		Category:   request.Params.Category,
		DeductFrom: request.Params.DeductFrom,
		Limit:      request.Params.Limit,
		Page:       request.Params.Page,
	})
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetRecordsdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	records := []common.Record{}
	for _, record := range data {
		value := record.Value
		if value < 0 {
			value *= -1
		}
		records = append(records, common.Record{
			Title:       record.Title,
			Description: record.Description,
			Type:        record.Type,
			Category:    record.Category,
			Id:          record.Id,
			Value:       value,
			CreatedAt:   record.CreatedAt,
			DeductFrom:  record.DeductFrom,
			Url:         record.Url,
		})
	}

	return GetRecords200JSONResponse(records), nil
}
