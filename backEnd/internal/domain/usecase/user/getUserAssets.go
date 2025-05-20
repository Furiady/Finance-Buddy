package user

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	"context"
)

// GetUserAssets implements UseCase.
func (u *useCase) GetUserAssets(ctx context.Context) (model.UserAssets, error) {
	userId := ctx.Value("userId").(string)

	userAssets, err := u.outbound.Repositories.UserAsset.GetAll(ctx, obModel.RequestGetUserAssets{
		UserId: userId,
	})
	if err != nil {
		return model.UserAssets{}, err
	}

	return  model.UserAssets{}.FromObModel(userAssets), nil
}
