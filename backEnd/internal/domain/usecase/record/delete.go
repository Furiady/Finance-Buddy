package record

import (
	obModel "backEnd/internal/outbound/model"
	"context"
)

// Delete implements UseCase.
func (u *useCase) Delete(ctx context.Context, recordId string) error {
	userId := ctx.Value("userId").(string)

	err := u.outbound.Repositories.Record.Delete(ctx, obModel.RequestDeleteRecord{
		UserId:   userId,
		RecordId: recordId,
	})
	if err != nil {
		return err
	}

	return nil
}
