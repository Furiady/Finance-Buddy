package transaction

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	"context"
)

// Get implements UseCase.
func (u *useCase) Get(ctx context.Context, transactionId string) (model.Transaction, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Transaction.Get(ctx, obModel.RequestFindTransaction{
		UserId:        userId,
		TransactionId: transactionId,
	})
	if err != nil {
		return model.Transaction{}, err
	}

	return model.Transaction{}.FromObModel(data), nil
}
