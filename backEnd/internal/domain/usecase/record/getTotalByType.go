package record

import (
	"backEnd/internal/domain/model"
	"context"
)

// GetTotalByType implements UseCase.
func (u *useCase) GetTotalByType(ctx context.Context, request model.RequestGetTotalByType) (map[string]int64, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Record.GetTotalByType(ctx, request.ToObModel(userId))
	if err != nil {
		return map[string]int64{}, err
	}

	return data, nil
}
