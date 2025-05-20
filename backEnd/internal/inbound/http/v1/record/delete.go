package record

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// DeleteRecord implements StrictServerInterface.
func (c *Controller) DeleteRecord(ctx context.Context, request DeleteRecordRequestObject) (DeleteRecordResponseObject, error) {
	err := c.Domain.UseCases.Record.Delete(ctx, request.RecordId)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return DeleteRecorddefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return DeleteRecord200JSONResponse{
		Message:   "Record deleted",
		Timestamp: time.Now().String(),
	}, nil
}
