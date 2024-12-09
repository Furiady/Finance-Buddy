package accessory

import (
	"backEnd/internal/domain/model"
	"context"
)

// GetAll implements UseCase.
func (u *useCase) GetAll(ctx context.Context) (model.Accessories, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Accessory.GetAll(ctx, userId)
	if err != nil {
		return nil, err
	}

	return model.Accessories{}.FromObModel(data), nil
}
