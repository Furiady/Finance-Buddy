package theme

import (
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"time"
)

// BuyTheme implements StrictServerInterface.
func (c *Controller) BuyTheme(ctx context.Context, request BuyThemeRequestObject) (BuyThemeResponseObject, error) {
	err := c.Domain.UseCases.Theme.BuyTheme(ctx, request.Body.ThemeId)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return BuyThemedefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}
	return BuyTheme200JSONResponse{
		Message:   "Theme bought",
		Timestamp: time.Now().String(),
	}, nil
}
