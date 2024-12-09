package transaction

import (
	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// UpdateTransaction implements StrictServerInterface.
func (c *Controller) UpdateTransaction(ctx context.Context, request UpdateTransactionRequestObject) (UpdateTransactionResponseObject, error) {
	err := c.Domain.UseCases.Transaction.Update(ctx, ucModel.RequestUpdateTransaction{
		Id:          request.TransactionId,
		Title:       request.Body.Title,
		Description: *request.Body.Description,
		Type:        request.Body.Type,
		Category:    request.Body.Category,
		Value:       request.Body.Value,
		CreatedAt:   request.Body.CreatedAt,
	})
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return UpdateTransactiondefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return UpdateTransaction200JSONResponse{
		Message:   "Transaction updated",
		Timestamp: time.Now().String(),
	}, nil
}
