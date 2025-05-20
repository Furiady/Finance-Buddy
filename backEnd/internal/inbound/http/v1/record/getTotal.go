package record

import (
	"backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// GetRecordTotal implements StrictServerInterface.
func (c *Controller) GetRecordTotal(ctx context.Context, request GetRecordTotalRequestObject) (GetRecordTotalResponseObject, error) {
	data, err := c.Domain.UseCases.Record.GetTotalByType(ctx, model.RequestGetTotalByType{
		StartDate: request.Params.StartDate,
		EndDate:   request.Params.EndDate,
	})
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetRecordTotaldefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	expense := data["Expense"]
	if expense < 0 {
		expense *= -1
	}

	return GetRecordTotal200JSONResponse{
		Expense: expense,
		Income:  data["Income"],
	}, nil
}
