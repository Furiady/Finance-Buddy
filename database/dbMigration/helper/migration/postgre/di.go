package postgre

import (
	"fmt"
	"strings"
	"time"

	"database/dbMigration/db/postgre"
	"database/dbMigration/helper/connection"
	"database/dbMigration/helper/migration"
	"database/dbMigration/helper/version"
	"database/dbMigration/migrator"

	"github.com/pkg/errors"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type (
	PostgreSQL struct {
		migrations      []migration.Migration
		migrationFiles  map[uint64]migration.Migration
		sql             *gorm.DB
		versions        []version.DataVersion
		executedVersion map[uint64]version.DataVersion
	}
)

func New(m migrator.Migrator) (*PostgreSQL, error) {
	orm, err := postgre.GetPostgre()
	if err != nil {
		return nil, errors.New("cannot established connection to postgres")
	}

	migrations := m.Postgre()(orm)
	if len(migrations) < 1 {
		return nil, errors.New("no sql migrations file")
	}

	var migrationFiles = make(map[uint64]migration.Migration)
	for _, m := range migrations {
		migrationFiles[m.Version()] = m
	}

	return &PostgreSQL{
		sql:            orm,
		migrations:     migrations,
		migrationFiles: migrationFiles,
	}, nil
}

func (p *PostgreSQL) Name() string {
	return connection.Postgre
}

func (p *PostgreSQL) Migrations() []migration.Migration {
	return p.migrations
}

func (p *PostgreSQL) Check(verbose bool) error {
	if !p.sql.Migrator().HasTable(version.MigrationTable) {
		if err := p.sql.Migrator().CreateTable(&version.DataVersion{}); err != nil {
			return err
		}
		p.versions = make([]version.DataVersion, 0)
		p.executedVersion = make(map[uint64]version.DataVersion)
		return nil
	}

	if err := p.sql.Model(&version.DataVersion{}).
		Order("version asc").
		Find(&p.versions).Error; err != nil {
		return err
	}

	p.executedVersion = make(map[uint64]version.DataVersion)
	for _, v := range p.versions {
		p.executedVersion[v.Version] = v
	}

	if verbose {
		for _, m := range p.migrations {
			if _, ok := p.executedVersion[m.Version()]; ok {
				logrus.StandardLogger().Infof("%d: UP", m.Version())
			} else {
				logrus.StandardLogger().Infof("%d: DOWN", m.Version())
			}
		}
	}
	return nil
}

func (p *PostgreSQL) CheckVersion(version version.Version) error {
	if _, ok := p.executedVersion[uint64(version)]; ok {
		return nil
	}
	return errors.New("record not found")
}

func (p *PostgreSQL) Versions() []version.DataVersion {
	return p.versions
}

func (p *PostgreSQL) logMigrated() {
	for _, v := range p.Versions() {
		if _, ok := p.migrationFiles[v.Version]; !ok {
			logrus.StandardLogger().Warnf("version %d - %s, already migrated but not available in current version",
				v.Version, v.Name)
		}
	}
}

func (p *PostgreSQL) Migrate(ver version.Version, specific bool) error {
	p.logMigrated()

	for _, m := range p.Migrations() {
		if specific {
			if m.Version() == uint64(ver) {
				if err := p.migrate(m); err != nil {
					return err
				}
				return nil
			}
			continue
		}

		if uint64(ver) < m.Version() {
			return nil
		}

		if _, ok := p.executedVersion[m.Version()]; ok {
			continue
		}

		if err := p.migrate(m); err != nil {
			return err
		}

		p.executedVersion[m.Version()] = version.DataVersion{Version: m.Version()}
	}
	return nil
}

func (p *PostgreSQL) migrate(m migration.Migration) error {
	logrus.StandardLogger().Infof("[%s] execute migration version %d", p.Name(), m.Version())
	if err := m.Migrate(); err != nil {
		logrus.StandardLogger().Errorf("[%s] error execute migration version %d: %+v", p.Name(), m.Version(),
			err.Error())
		return err
	}

	newVersion := version.DataVersion{
		ID:          fmt.Sprintf("%d_%s", m.Version(), strings.ReplaceAll(m.Name(), " ", "_")),
		Version:     m.Version(),
		Name:        m.Name(),
		ExecuteTime: time.Now().Format(time.RFC3339),
	}
	if err := p.sql.Create(&newVersion).Error; err != nil {
		logrus.StandardLogger().Errorf("[%s] error execute migration version %d: %+v", p.Name(), m.Version(),
			err.Error())
		return err
	} else {
		p.versions = append(p.versions, newVersion)
		p.executedVersion[newVersion.Version] = newVersion
	}
	logrus.StandardLogger().Infof("[%s] finish execute migration version %d", p.Name(), m.Version())
	return nil
}

func (p *PostgreSQL) Rollback(ver version.Version, specific bool) error {
	p.logMigrated()

	latest := p.versions[len(p.versions)-1]
	if !specific && latest.Version < uint64(ver) {
		return nil
	}

	for i := len(p.migrations) - 1; i >= 0; i-- {
		if specific {
			if p.migrations[i].Version() == uint64(ver) {
				if err := p.rollback(p.migrations[i]); err != nil {
					return err
				}
				return nil
			}
			continue
		}

		if latest.Version < p.migrations[i].Version() {
			continue
		}

		if p.migrations[i].Version() <= uint64(ver) {
			return nil
		}

		if _, ok := p.executedVersion[p.migrations[i].Version()]; ok {
			if err := p.rollback(p.migrations[i]); err != nil {
				return err
			}
			delete(p.executedVersion, p.migrations[i].Version())
		}
	}
	return nil
}

func (p *PostgreSQL) rollback(m migration.Migration) error {
	logrus.StandardLogger().Infof("[%s] execute rollback version %d", p.Name(), m.Version())
	if err := m.Rollback(); err != nil {
		logrus.StandardLogger().Errorf("[%s] error execute rollback version %d: %+v", p.Name(), m.Version(),
			err.Error())
		return err
	}

	newVersion := version.DataVersion{}
	if err := p.sql.Table(version.MigrationTable).
		Where("version = ?", m.Version()).
		First(&newVersion).Error; err != nil {
		return err
	}

	if err := p.sql.Delete(&newVersion).Error; err != nil {
		logrus.StandardLogger().Errorf("[%s] error execute rollback version %d: %+v", p.Name(), m.Version(),
			err.Error())
		return err
	}
	logrus.StandardLogger().Infof("[%s] finish execute rollback version %d", p.Name(), m.Version())
	return nil
}
