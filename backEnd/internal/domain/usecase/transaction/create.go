package transaction

import (
	"backEnd/internal/domain/model"
	"context"
)

// Create implements UseCase.
func (u *useCase) Create(ctx context.Context, request model.RequestCreateTransaction) error {
	userId := ctx.Value("userId").(string)

	err := u.outbound.Repositories.Transaction.Create(ctx, request.ToObModel(userId))
	if err != nil {
		return err
	}

	_, err = u.outbound.Repositories.BalanceCategory.GetIdByName(ctx, request.Category)
	if err != nil {
		return err
	}

	return nil
}
