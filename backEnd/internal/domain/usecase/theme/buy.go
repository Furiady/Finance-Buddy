package theme

import (
	obModel "backEnd/internal/outbound/model"
	pkgError "backEnd/pkg/constant/error"
	"context"
)

// BuyTheme implements UseCase.
func (u *useCase) BuyTheme(ctx context.Context, themeId string) error {
	userId := ctx.Value("userId").(string)

	err := u.outbound.Repositories.Theme.CheckStatusOwned(ctx, userId, themeId)
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

	themeData, err := u.outbound.Repositories.Theme.Get(ctx, themeId)
	if err != nil {
		return err
	}
	themePrice := themeData.Price

	deductedCoin := userCoin - themePrice
	if deductedCoin < 0 {
		return pkgError.ErrCoinNotEnough
	}

	err = u.outbound.Repositories.User.UpdateCoin(ctx, userId, deductedCoin)
	if err != nil {
		return err
	}

	err = u.outbound.Repositories.Theme.UpdateStatusOwned(ctx, userId, themeId)
	if err != nil {
		return err
	}

	return nil
}
