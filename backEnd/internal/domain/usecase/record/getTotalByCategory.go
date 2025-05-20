package record

import (
	"backEnd/internal/domain/model"
	"context"
)

// GetTotalByCategory implements UseCase.
func (u *useCase) GetTotalByCategory(ctx context.Context, request model.RequestGetTotalByCategory) (map[string]int64, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Record.GetAll(ctx, request.ToObModel(userId))
	if err != nil {
		return map[string]int64{}, err
	}

	result := map[string]int64{}
	for _, record := range data {
		if _, exists := result[record.Category]; !exists {
			result[record.Category] = 0
		}
		result[record.Category] += record.Value
	}

	return result, nil
}

