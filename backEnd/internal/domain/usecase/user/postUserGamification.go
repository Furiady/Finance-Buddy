package user

import (
	obModel "backEnd/internal/outbound/model"
	"context"
	"strings"
)

// PostUserGamification implements UseCase.
func (u *useCase) PostUserGamification(ctx context.Context, gamification string) error {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.User.Get(ctx, obModel.RequestGetUser{
		UserId: &userId,
	})
	if err != nil {
		return err
	}

	if strings.Contains(gamification, "assets/images/pets/") {
		data.Gamification = replaceAtIndex(data.Gamification, 0, gamification[len("assets/images/pets/"):len("assets/images/pets/")+1])
	} else if strings.Contains(gamification, "assets/images/accessories/") {
		data.Gamification = replaceAtIndex(data.Gamification, 2, gamification[len("assets/images/accessories/"):len("assets/images/accessories/")+1])
	} else if strings.Contains(gamification, "assets/images/themes/") {
		data.Gamification = replaceAtIndex(data.Gamification, 4, gamification[len("assets/images/themes/"):len("assets/images/themes/")+1])
	}

	err = u.outbound.Repositories.User.UpdateGamification(ctx, userId, data.Gamification)
	if err != nil {
		return err
	}

	return nil
}

func replaceAtIndex(in string, i int, r string) string {
	out := []rune(in)
	out[i] = []rune(r)[0]
	return string(out)
}
