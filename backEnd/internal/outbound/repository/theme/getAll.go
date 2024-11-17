package theme

import (
	"backEnd/internal/outbound/model"
	"context"
)

// FindThemes implements Repository.
func (r *repository) GetAll(ctx context.Context, userId string) (model.Themes, error) {
	var (
		result model.Themes
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
		Table(model.Theme{}.TableName()).
		Select("themes.*, user_theme.status").
		Joins("LEFT JOIN user_theme ON user_theme.theme_id = themes.id AND user_theme.user_id = ?", userId).
		Find(&result).Error
	if err != nil {
		return model.Themes{}, err
	}

	return result, nil
}
