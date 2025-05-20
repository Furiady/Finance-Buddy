package quest

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// ClaimQuest implements StrictServerInterface.
func (c *Controller) ClaimQuest(ctx context.Context, request ClaimQuestRequestObject) (ClaimQuestResponseObject, error) {
	err := c.Domain.UseCases.Quest.Claim(ctx, request.Id)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return ClaimQuestdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return ClaimQuest200JSONResponse{
		Message:   "Success",
		Timestamp: time.Now().String(),
	}, nil
}