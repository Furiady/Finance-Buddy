package user_quest

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Create implements Repository.
func (r *repository) Create(ctx context.Context, request model.UserQuest) error {
	db := r.resource.DatabaseSQL.DB

	err := db.Table(request.TableName()).
		Create(&request).Error
	if err != nil {
		return err
	}

	return nil
}
