package user

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	"context"
)

// GetUserLiabilities implements UseCase.
func (u *useCase) GetUserLiabilities(ctx context.Context) (model.UserLiabilities, error) {
	userId := ctx.Value("userId").(string)

	userAssets, err := u.outbound.Repositories.UserAsset.GetAll(ctx, obModel.RequestGetUserAssets{
		UserId: userId,
	})
	if err != nil {
		return model.UserLiabilities{}, err
	}

	return  model.UserLiabilities{}.FromObModel(userAssets), nil
}
