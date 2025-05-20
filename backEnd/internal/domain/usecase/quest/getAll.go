package quest

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	"context"
	"time"
)

// GetAll implements UseCase.
func (u *useCase) GetAll(ctx context.Context) (model.Quests, error) {
	userId := ctx.Value("userId").(string)

	data, err := u.outbound.Repositories.Quest.GetAll(ctx, userId)
	if err != nil {
		return model.Quests{}, err
	}

	for _, quest := range data {
		switch quest.Id {
		case "1":
			updatedAt, err := time.Parse(time.RFC3339, quest.UpdatedAt)
			if err != nil {
				return model.Quests{}, err
			}
			currentDay := updatedAt.Day()
			if currentDay != time.Now().Day() {
				quest.Count = 0
			}

			if quest.Count < quest.Limit && !quest.Status {
				quest.Status = true
				u.outbound.Repositories.UserQuest.Update(ctx, obModel.UserQuest{
					UserId:    userId,
					QuestId:   quest.Id,
					Status:    true,
					Count:     quest.Count,
					UpdatedAt: time.Now().Format("20060102"),
				})
			}
		case "2":
			updatedAt, err := time.Parse(time.RFC3339, quest.UpdatedAt)
			if err != nil {
				return model.Quests{}, err
			}
			currentDay := updatedAt.Day()
			if currentDay != time.Now().Day() {
				quest.Count = 0
			}

			if quest.Count < quest.Limit && !quest.Status {
				recordCount, err := u.outbound.Repositories.Record.Count(ctx, obModel.RequestCount{
					UserId:    userId,
					StartDate: time.Now().Format("20060102"),
					EndDate:   time.Now().Format("20060102") + " 23:59:59",
				})
				if err != nil {
					return model.Quests{}, err
				}

				if recordCount > int64(quest.Count) {
					quest.Status = true
					u.outbound.Repositories.UserQuest.Update(ctx, obModel.UserQuest{
						UserId:    userId,
						QuestId:   quest.Id,
						Status:    true,
						Count:     quest.Count,
						UpdatedAt: time.Now().Format("20060102"),
					})
				}
			}
		case "3":
			updatedAt, err := time.Parse(time.RFC3339, quest.UpdatedAt)
			if err != nil {
				return model.Quests{}, err
			}
			currentDay := updatedAt.Day()
			if currentDay != time.Now().Day() {
				quest.Count = 0
			}

			if quest.Count < quest.Limit && !quest.Status {
				recordType := "Expense"
				records, err := u.outbound.Repositories.Record.GetAll(ctx, obModel.RequestGetAllRecord{
					UserId:     userId,
					StartDate:  time.Now().Format("20060102"),
					EndDate:    time.Now().Format("20060102") + " 23:59:59",
					RecordType: &recordType,
				})
				if err != nil {
					return model.Quests{}, err
				}

				for _, record := range records {
					if record.Url != nil {
						quest.Status = true
						u.outbound.Repositories.UserQuest.Update(ctx, obModel.UserQuest{
							UserId:    userId,
							QuestId:   quest.Id,
							Status:    true,
							Count:     quest.Count,
							UpdatedAt: time.Now().Format("20060102"),
						})
						break
					}
				}
			}
		}
	}

	return model.Quests{}.FromObModel(data), err
}
