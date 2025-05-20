package record

import (
	ucModel "backEnd/internal/domain/model"
	"backEnd/internal/inbound/http/v1/common"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"mime/multipart"
	"strconv"
	"time"
)

// UpdateRecord implements StrictServerInterface.
func (c *Controller) UpdateRecord(ctx context.Context, request UpdateRecordRequestObject) (UpdateRecordResponseObject, error) {
	multipartForm, err := request.Body.ReadForm(4 << 20)
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return UpdateRecorddefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	var title string = multipartForm.Value["title"][0]
	var recordType string = multipartForm.Value["type"][0]
	var category string = multipartForm.Value["category"][0]
	var valueStr string = multipartForm.Value["value"][0]
	var createdAt string = multipartForm.Value["createdAt"][0]

	var description *string
	if desc, ok := multipartForm.Value["description"]; ok && len(desc) > 0 {
		description = &desc[0]
	}

	var deductFrom *string
	if deduct, ok := multipartForm.Value["deductFrom"]; ok && len(deduct) > 0 {
		deductFrom = &deduct[0]
	}

	var image *multipart.FileHeader
	if fileHeaders, ok := multipartForm.File["image"]; ok && len(fileHeaders) > 0 {
		image = fileHeaders[0]
	}

	value, err := strconv.ParseInt(valueStr, 10, 64)
	if err != nil {
		return UpdateRecorddefaultJSONResponse{
			StatusCode: 400,
			Body: common.BaseResponse{
				Message:   "invalid value",
				Timestamp: time.Now().String(),
			},
		}, err
	}

	err = c.Domain.UseCases.Record.Update(ctx, ucModel.RequestUpdateRecord{
		Id:          request.RecordId,
		Title:       title,
		Description: description,
		Type:        recordType,
		Category:    category,
		Value:       value,
		CreatedAt:   createdAt,
		DeductFrom:  deductFrom,
		Image:       image,
	})
	if err != nil {
		statusCode := pkgHelper.FromErrorMap(err, common.ErrorMap)
		return UpdateRecorddefaultJSONResponse{
			StatusCode: statusCode,
			Body: common.BaseResponse{
				Message:   err.Error(),
				Timestamp: time.Now().String(),
			},
		}, nil
	}

	return UpdateRecord200JSONResponse{
		Message:   "Record updated",
		Timestamp: time.Now().String(),
	}, nil
}
