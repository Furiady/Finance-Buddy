package auth

import (
	"context"
	"time"

	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
)

// Register implements StrictServerInterface.
func (c *Controller) Register(ctx context.Context, request RegisterRequestObject) (RegisterResponseObject, error) {
	err := c.Domain.UseCases.Auth.Register(ctx, ucModel.RegisterRequest{
		Username: request.Body.Username,
		Email:    request.Body.Email,
		Password: request.Body.Password,
	})

	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return RegisterdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}
	return Register204Response{}, nil
}
