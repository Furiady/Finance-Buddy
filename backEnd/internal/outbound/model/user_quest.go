package model

type (
	UserQuest struct {
		UserId    string `gorm:"column:user_id"`
		QuestId   string `gorm:"column:quest_id"`
		Status    bool   `gorm:"column:status"`
		Count     int    `gorm:"column:count"`
		UpdatedAt string `gorm:"column:updated_at"`
	}
)

func (UserQuest) TableName() string {
	return "user_quest"
}
