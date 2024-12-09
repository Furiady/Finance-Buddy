package transaction

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// DeleteTransaction implements StrictServerInterface.
func (c *Controller) DeleteTransaction(ctx context.Context, request DeleteTransactionRequestObject) (DeleteTransactionResponseObject, error) {
	err := c.Domain.UseCases.Transaction.Delete(ctx, request.TransactionId)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return DeleteTransactiondefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return DeleteTransaction200JSONResponse{
		Message:   "Transaction deleted",
		Timestamp: time.Now().String(),
	}, nil
}
