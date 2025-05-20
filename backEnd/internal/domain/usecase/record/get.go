package record

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	"context"
)

// Get implements UseCase.
func (u *useCase) Get(ctx context.Context, recordId string) (model.Record, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Record.Get(ctx, obModel.RequestFindRecord{
		UserId:   userId,
		RecordId: recordId,
	})
	if err != nil {
		return model.Record{}, err
	}

	return model.Record{}.FromObModel(data), nil
}
