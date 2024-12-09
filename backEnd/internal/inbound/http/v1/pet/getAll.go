package pet

import (
	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"strconv"
	"time"
)

// GetAll implements StrictServerInterface.
func (c *Controller) GetAll(ctx context.Context, request GetAllRequestObject) (GetAllResponseObject, error) {
	data, err := c.Domain.UseCases.Pet.GetAll(ctx)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return GetAlldefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}
	return GetAll200JSONResponse(FromUcModel(data)), nil
}

func FromUcModel(data ucModel.Pets) []common.Pet {
	res := []common.Pet{}
	for _, d := range data {
		res = append(res, common.Pet{
			Id:     strconv.Itoa(d.Id),
			Path:    d.Path,
			Name:   d.Name,
			Price:  d.Price,
			Status: d.Status,
		})
	}
	return res
}
