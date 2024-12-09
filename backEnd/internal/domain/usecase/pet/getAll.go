package pet

import (
	"backEnd/internal/domain/model"
	"context"
)

// GetAll implements UseCase.
func (u *useCase) GetAll(ctx context.Context) (model.Pets, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Pet.GetAll(ctx, userId)
	if err != nil {
		return nil, err
	}

	return model.Pets{}.FromObModel(data), nil
}
