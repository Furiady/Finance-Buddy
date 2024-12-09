package pet

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// BuyPet implements StrictServerInterface.
func (c *Controller) BuyPet(ctx context.Context, request BuyPetRequestObject) (BuyPetResponseObject, error) {
	err := c.Domain.UseCases.Pet.BuyPet(ctx, request.Body.PetId)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return BuyPetdefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}
	return BuyPet200JSONResponse{
		Message:   "success",
		Timestamp: time.Now().String(),
	}, nil
}
