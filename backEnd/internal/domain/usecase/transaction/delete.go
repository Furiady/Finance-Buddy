package transaction

import (
	obModel "backEnd/internal/outbound/model"
	"context"
)

// Delete implements UseCase.
func (u *useCase) Delete(ctx context.Context, transactionId string) error {
	userId := ctx.Value("userId").(string)

	err := u.outbound.Repositories.Transaction.Delete(ctx, obModel.RequestDeleteTransaction{
		UserId:        userId,
		TransactionId: transactionId,
	})
	if err != nil {
		return err
	}

	return nil
}
