package user

import (
	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// GetUserLiabilities implements StrictServerInterface.
func (c *Controller) GetUserLiabilities(ctx context.Context, request GetUserLiabilitiesRequestObject) (GetUserLiabilitiesResponseObject, error) {
	data, err := c.Domain.UseCases.User.GetUserLiabilities(ctx)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetUserLiabilitiesdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return GetUserLiabilities200JSONResponse(fromUcModelLiabilities(data)), nil
}

func fromUcModelLiabilities(data ucModel.UserLiabilities) []ValueCount {
	result := []ValueCount{}
	for _, value := range data {
		result = append(result, ValueCount{
			Category: value.Category,
			Value:    value.Value,
		})
	}

	return result
}
