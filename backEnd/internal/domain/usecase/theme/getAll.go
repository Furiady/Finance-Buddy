package theme

import (
	"backEnd/internal/domain/model"
	"context"
)

// GetAll implements UseCase.
func (u *useCase) GetAll(ctx context.Context) (model.Themes, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Theme.GetAll(ctx, userId)
	if err != nil {
		return nil, err
	}

	return model.Themes{}.FromObModel(data), nil
}
