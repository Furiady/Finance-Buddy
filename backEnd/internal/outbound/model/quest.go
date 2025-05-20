package model

type (
	Quest struct {
		Id          string `gorm:"column:id"`
		Title       string `gorm:"column:title"`
		Description string `gorm:"column:description"`
		Reward      int    `gorm:"column:reward"`
		Cooldown    int    `gorm:"column:cooldown"`
		Status      bool   `gorm:"column:status"`
		Count       int    `gorm:"column:count"`
		Limit       int    `gorm:"column:limit"`
		UpdatedAt   string `gorm:"column:updated_at"`
	}
	Quests []Quest
)

func (Quest) TableName() string {
	return "quests"
}
