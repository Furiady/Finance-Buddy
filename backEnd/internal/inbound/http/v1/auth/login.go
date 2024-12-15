package auth

import (
	"context"
	"time"

	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
)

// Login implements StrictServerInterface.
func (c *Controller) Login(ctx context.Context, request LoginRequestObject) (LoginResponseObject, error) {
	token, err := c.Domain.UseCases.Auth.Login(ctx, ucModel.LoginRequest{
		Username: request.Body.Username,
		Password: request.Body.Password,
	})
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return LogindefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return Login200JSONResponse{
		Token: *token,
	}, nil
}
