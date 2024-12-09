package accessory

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// BuyAccessory implements StrictServerInterface.
func (c *Controller) BuyAccessory(ctx context.Context, request BuyAccessoryRequestObject) (BuyAccessoryResponseObject, error) {
	err := c.Domain.UseCases.Accessory.BuyAccessory(ctx, request.Body.AccessoryId)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return BuyAccessorydefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}
	return BuyAccessory200JSONResponse{
		Message:   "success",
		Timestamp: time.Now().String(),
	}, nil
}
