package quest

import (
	obModel "backEnd/internal/outbound/model"
	pkgError "backEnd/pkg/constant/error"
	"context"
	"time"
)

// Claim implements UseCase.
func (u *useCase) Claim(ctx context.Context, questId string) error {
	userId := ctx.Value("userId").(string)

	quest, err := u.outbound.Repositories.UserQuest.Get(ctx, userId, questId)
	if err != nil {
		return err
	}

	if quest.Status {
		questDetail, err := u.outbound.Repositories.Quest.Get(ctx, questId)
		if err != nil {
			return err
		}

		userDetail, err := u.outbound.Repositories.User.Get(ctx, obModel.RequestGetUser{
			UserId: &userId,
		})
		if err != nil {
			return err
		}

		err = u.outbound.Repositories.User.UpdateCoin(ctx, userId, userDetail.Coin+questDetail.Reward)
		if err != nil {
			return err
		}

		err = u.outbound.Repositories.UserQuest.Update(ctx, obModel.UserQuest{
			UserId:    userId,
			QuestId:   questId,
			Status:    false,
			Count:     quest.Count + 1,
			UpdatedAt: time.Now().Format("20060102"),
		})
		if err != nil {
			return err
		}
	} else {
		return pkgError.ErrBadRequest
	}

	return nil
}
