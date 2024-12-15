package auth

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	pkgError "backEnd/pkg/constant/error"
	"context"
)

// Register implements UseCase.
func (u *useCase) Register(ctx context.Context, request model.RegisterRequest) error {
	user, err := u.outbound.Repositories.User.Get(ctx, obModel.RequestGetUser{
		Username: &request.Username,
	})
	if err != nil {
		return err
	}

	if user.Id != 0 {
		return pkgError.ErrBadRequest
	}

	user, err = u.outbound.Repositories.User.Get(ctx, obModel.RequestGetUser{
		Email: &request.Email,
	})
	if err != nil {
		return err
	}

	if user.Id != 0 {
		return pkgError.ErrBadRequest
	}

	err = u.outbound.Repositories.User.Create(ctx, request.ToObModel())
	if err != nil {
		return err
	}

	return nil
}
