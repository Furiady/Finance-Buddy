package user

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"strconv"
	"time"

	"github.com/oapi-codegen/runtime/types"
)

// GetUser implements StrictServerInterface.
func (c *Controller) GetUser(ctx context.Context, request GetUserRequestObject) (GetUserResponseObject, error) {
	data, err := c.Domain.UseCases.User.GetUser(ctx)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetUserdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return GetUser200JSONResponse{
		common.User{
			Id:       strconv.Itoa(data.Id),
			Email:    types.Email(data.Email),
			Username: data.Username,
			Pin:      data.Pin,
			Balance:  int64(data.Balance),
			Coin:     data.Coin,
		},
	}, nil
}
