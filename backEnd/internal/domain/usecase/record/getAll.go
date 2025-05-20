package record

import (
	"backEnd/internal/domain/model"
	"context"
)

// GetAll implements UseCase.
func (u *useCase) GetAll(ctx context.Context, request model.RequestGetAllRecord) (model.Records, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Record.GetAll(ctx, request.ToObModel(userId))
	if err != nil {
		return model.Records{}, err
	}

	return model.Records{}.FromObModel(data), nil
}
