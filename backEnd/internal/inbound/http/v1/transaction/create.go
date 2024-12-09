package transaction

import (
	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// CreateTransaction implements StrictServerInterface.
func (c *Controller) CreateTransaction(ctx context.Context, request CreateTransactionRequestObject) (CreateTransactionResponseObject, error) {
	
	err := c.Domain.UseCases.Transaction.Create(ctx, ucModel.RequestCreateTransaction{
		Title:       request.Body.Title,
		Description: *request.Body.Description,
		Type:        request.Body.Type,
		Category:    request.Body.Category,
		Value:       request.Body.Value,
		CreatedAt:   request.Body.CreatedAt,
	})
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return CreateTransactiondefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return CreateTransaction200JSONResponse{
		Message:   "Transaction created",
		Timestamp: time.Now().String(),
	}, nil
}
