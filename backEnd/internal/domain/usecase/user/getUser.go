package user

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	"context"
)

// GetUser implements UseCase.
func (u *useCase) GetUser(ctx context.Context) (model.User, error) {
	userId := ctx.Value("userId").(string)

	userData, err := u.outbound.Repositories.User.Get(ctx, obModel.RequestGetUser{
		UserId: &userId,
	})
	if err != nil {
		return model.User{}, err
	}

	return model.User{}.FromObModel(userData), err
}
