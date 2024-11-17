package auth

import (
	"context"
	"time"

	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"

	"github.com/gin-gonic/gin"
)

// Login implements StrictServerInterface.
func (c *Controller) Login(ctx context.Context, request LoginRequestObject) (LoginResponseObject, error) {
	cookie, err := c.Domain.UseCases.Auth.Login(ctx, ucModel.LoginRequest{
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

	ctx.(*gin.Context).SetCookie(cookie.Name, cookie.Value, cookie.MaxAge, cookie.Path, cookie.Domain, cookie.Secure, cookie.HttpOnly)

	return Login204Response{}, nil
}
