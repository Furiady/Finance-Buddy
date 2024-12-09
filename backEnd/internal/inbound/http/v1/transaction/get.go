package transaction

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// GetTransaction implements StrictServerInterface.
func (c *Controller) GetTransaction(ctx context.Context, request GetTransactionRequestObject) (GetTransactionResponseObject, error) {
	data, err := c.Domain.UseCases.Transaction.Get(ctx, request.TransactionId)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetTransactiondefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return GetTransaction200JSONResponse{
		Title:       data.Title,
		Description: data.Description,
		Type:        data.Type,
		Category:    data.Category,
		Id:          data.Id,
		Value:       data.Value,
		CreatedAt:   data.CreatedAt,
		Url:         data.Url,
	}, nil
}
