package user

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, request model.RequestGetUser) (model.User, error) {
	var (
		result model.User
		db     = r.resource.DatabaseSQL.DB

		query = db.WithContext(ctx).
			Table(model.User{}.TableName()).
			Select("users.*")
	)

	if request.Username != nil {
		query = query.Where("users.username = ?", *request.Username)
	}
	if request.UserId != nil {
		query = query.Where("users.id = ?", *request.UserId)
	}
	if request.Email != nil {
		query = query.Where("users.email = ?", *request.Email)
	}

	err := query.Find(&result).Error
	if err != nil {
		return model.User{}, err
	}

	return result, nil
}
