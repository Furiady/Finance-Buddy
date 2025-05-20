package auth

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	pkgError "backEnd/pkg/constant/error"
	"context"
	"strconv"
	"time"
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

	err = u.outbound.Repositories.User.Create(ctx, request.ToObModel())
	if err != nil {
		return err
	}

	user, err = u.outbound.Repositories.User.Get(ctx, obModel.RequestGetUser{
		Email: &request.Email,
	})
	if err != nil {
		return err
	}

	if user.Id == 0 {
		return pkgError.ErrBadRequest
	}

	u.outbound.Repositories.Pet.UpdateStatusOwned(ctx, strconv.Itoa(user.Id), "1")

	u.outbound.Repositories.Theme.UpdateStatusOwned(ctx, strconv.Itoa(user.Id), "1")

	u.createUserQuest(ctx, user.Id)

	return nil
}

func (u *useCase) createUserQuest(ctx context.Context, userId int) error {
	userQuest := obModel.UserQuest{
		UserId:    strconv.Itoa(userId),
		Status:    false,
		Count:     0,
		UpdatedAt: time.Now().Format("20060102"),
	}
	userQuest.QuestId = "1"
	u.outbound.Repositories.UserQuest.Create(ctx, userQuest)

	userQuest.QuestId = "2"
	u.outbound.Repositories.UserQuest.Create(ctx, userQuest)

	userQuest.QuestId = "3"
	u.outbound.Repositories.UserQuest.Create(ctx, userQuest)

	return nil
}
