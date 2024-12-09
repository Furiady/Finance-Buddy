package transaction

import (
	"backEnd/internal/domain/model"
	"context"
)

// Update implements UseCase.
func (u *useCase) Update(ctx context.Context, request model.RequestUpdateTransaction) error {
	userId := ctx.Value("userId").(string)

	err := u.outbound.Repositories.Transaction.Update(ctx, request.ToObModel(userId))
	if err != nil {
		return err
	}

	return nil
}
