package user

import (
	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// GetUserAssets implements StrictServerInterface.
func (c *Controller) GetUserAssets(ctx context.Context, request GetUserAssetsRequestObject) (GetUserAssetsResponseObject, error) {
	data, err := c.Domain.UseCases.User.GetUserAssets(ctx)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetUserAssetsdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return GetUserAssets200JSONResponse(fromUcModelAssets(data)), nil
}

func fromUcModelAssets(data ucModel.UserAssets) []ValueCount {
	result := []ValueCount{}
	for _, value := range data {
		result = append(result, ValueCount{
			Category: value.Category,
			Value:    value.Value,
		})
	}

	return result
}
