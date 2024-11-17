package theme

import (
	"backEnd/internal/outbound/model"
	"context"
)

// Get implements Repository.
func (r *repository) Get(ctx context.Context, themeId string) (model.Theme, error) {
	var (
		result model.Theme
		db     = r.resource.DatabaseSQL.DB
	)

	err := db.WithContext(ctx).
        Table(model.Theme{}.TableName()).
		Select("themes.*").
		Where("themes.id = ?", themeId).
        Find(&result).Error
	if err != nil {
		return model.Theme{}, err
	}

	return result, nil
}