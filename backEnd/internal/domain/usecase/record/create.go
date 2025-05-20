package record

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	"context"
	"fmt"
	"strconv"
	"time"
)

// Create implements UseCase.
func (u *useCase) Create(ctx context.Context, request model.RequestCreateRecord) error {
	userId := ctx.Value("userId").(string)

	var categoryId *string
	var err error
	switch request.Type {
	case "Expense":
		if request.Value > 0 {
			request.Value = -request.Value
		}

		categoryId, err = u.outbound.Repositories.AssetCategory.GetIdByName(ctx, *request.DeductFrom)
		if err != nil {
			return err
		}

	case "Income":
		categoryId, err = u.outbound.Repositories.AssetCategory.GetIdByName(ctx, request.Category)
		if err != nil {
			return err
		}
	}

	var urlPtr *string
	if request.Image != nil {
		fileName := strconv.Itoa(int(time.Now().Unix()))
		filePath := userId + "/" + fileName
		image, _ := request.Image.Open()

		go u.outbound.Firebase.Record.Upload(ctx, filePath, image)

		url := fmt.Sprintf("https://firebasestorage.googleapis.com/v0/b/"+ u.resource.ConfigFirebase.ProjectId + "/o/bills%%2F" + userId + "%%2F" + fileName + "?alt=media")
		urlPtr = &url
	}

	err = u.outbound.Repositories.Record.Create(ctx, request.ToObModel(userId, urlPtr))
	if err != nil {
		return err
	}

	userAsset, err := u.outbound.Repositories.UserAsset.Get(ctx, obModel.RequestGetUserAsset{
		UserId:     userId,
		CategoryId: *categoryId,
	})
	if err != nil {
		return err
	}

	userAsset.Value += request.Value
	err = u.outbound.Repositories.UserAsset.Save(ctx, obModel.RequestSaveUserAsset{
		UserId:     userId,
		CategoryId: *categoryId,
		Value:      userAsset.Value,
	})
	if err != nil {
		return err
	}

	return nil
}
