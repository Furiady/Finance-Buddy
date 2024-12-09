package accessory

import (
	obModel "backEnd/internal/outbound/model"
	pkgError "backEnd/pkg/constant/error"
	"context"
)

// BuyAccessory implements UseCase.
func (u *useCase) BuyAccessory(ctx context.Context, accessoryId string) error {
	userId := ctx.Value("userId").(string)

	err := u.outbound.Repositories.Accessory.CheckStatusOwned(ctx, userId, accessoryId)
	if err != nil {
		return err
	}

	userData, err := u.outbound.Repositories.User.Get(ctx, obModel.RequestGetUser{
		UserId: &userId,
	})
	if err != nil {
		return err
	}
	userCoin := userData.Coin

	accessoryData, err := u.outbound.Repositories.Accessory.Get(ctx, accessoryId)
	if err != nil {
		return err
	}
	accessoryPrice := accessoryData.Price

	deductedCoin := userCoin - accessoryPrice
	if deductedCoin < 0 {
		return pkgError.ErrCoinNotEnough
	}

	err = u.outbound.Repositories.User.UpdateCoin(ctx, userId, deductedCoin)
	if err != nil {
		return err
	}

	err = u.outbound.Repositories.Accessory.UpdateStatusOwned(ctx, userId, accessoryId)
	if err != nil {
		return err
	}

	return nil
}
