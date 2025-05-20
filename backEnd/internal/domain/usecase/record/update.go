package record

import (
	"backEnd/internal/domain/model"
	"context"
	"fmt"
	"strconv"
	"time"
)

// Update implements UseCase.
func (u *useCase) Update(ctx context.Context, request model.RequestUpdateRecord) error {
	userId := ctx.Value("userId").(string)

	var urlPtr *string
	if request.Image != nil {
		fileName := strconv.Itoa(int(time.Now().Unix()))
		filePath := userId + "/" + fileName
		image, _ := request.Image.Open()

		go u.outbound.Firebase.Record.Upload(ctx, filePath, image)

		url := fmt.Sprintf("https://firebasestorage.googleapis.com/v0/b/" + u.resource.ConfigFirebase.ProjectId + "/o/bills%%2F" + userId + "%%2F" + fileName + "?alt=media")
		urlPtr = &url
	}

	err := u.outbound.Repositories.Record.Update(ctx, request.ToObModel(userId, urlPtr))
	if err != nil {
		return err
	}

	return nil
}
