package user

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// PostUserGamification implements StrictServerInterface.
func (c *Controller) PostUserGamification(ctx context.Context, request PostUserGamificationRequestObject) (PostUserGamificationResponseObject, error) {
	err := c.Domain.UseCases.User.PostUserGamification(ctx, request.Body.Gamification)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return PostUserGamificationdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return PostUserGamification200JSONResponse{
		Message:   "Success",
		Timestamp: time.Now().String(),
	}, nil
}
