package pet

import (
	obModel "backEnd/internal/outbound/model"
	pkgError "backEnd/pkg/constant/error"
	"context"
)

// BuyPet implements UseCase.
func (u *useCase) BuyPet(ctx context.Context, petId string) error {
	userId := ctx.Value("userId").(string)

	err := u.outbound.Repositories.Pet.CheckStatusOwned(ctx, userId, petId)
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

	petData, err := u.outbound.Repositories.Pet.Get(ctx, petId)
	if err != nil {
		return err
	}
	petPrice := petData.Price

	deductedCoin := userCoin - petPrice
	if deductedCoin < 0 {
		return pkgError.ErrCoinNotEnough
	}

	err = u.outbound.Repositories.User.UpdateCoin(ctx, userId, deductedCoin)
	if err != nil {
		return err
	}

	err = u.outbound.Repositories.Pet.UpdateStatusOwned(ctx, userId, petId)
	if err != nil {
		return err
	}

	return nil
}
