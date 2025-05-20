package record

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// GetRecord implements StrictServerInterface.
func (c *Controller) GetRecord(ctx context.Context, request GetRecordRequestObject) (GetRecordResponseObject, error) {
	data, err := c.Domain.UseCases.Record.Get(ctx, request.RecordId)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetRecorddefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return GetRecord200JSONResponse{
		Title:       data.Title,
		Description: data.Description,
		Type:        data.Type,
		Category:    data.Category,
		Id:          data.Id,
		Value:       data.Value,
		CreatedAt:   data.CreatedAt,
		DeductFrom:  data.DeductFrom,
		Url:         data.Url,
	}, nil
}
