package version

import (
	"math"
)

type Version uint64

const MigrationTable = "sdk_migrations"
const LatestVersion Version = math.MaxUint64
const NoVersion Version = 0

type (
	DataVersion struct {
		// Note: concat Version and NeutralizedName
		// NeutralizedName is name replace space with _
		ID          string `json:"id" gorm:"primaryKey;column=id"`
		Version     uint64 `json:"version" gorm:"index;column=version"`
		Name        string `json:"name" gorm:"column=name"`
		ExecuteTime string `json:"execute_time" gorm:"column=execute_time"`
	}
)

func (d *DataVersion) TableName() string {
	return MigrationTable
}
