package sdkMigration

import (
	"os"

	"github.com/sirupsen/logrus"
	"github.com/urfave/cli/v2"
	"github.com/Furiady/skripsi/db-migration/dbMigration/command"
	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/migration"
	"github.com/Furiady/skripsi/db-migration/dbMigration/migrator"
	"gorm.io/gorm"
)

type (
	Cli struct {
		migrator *migrator.Migrator
	}
)

func New() *Cli {
	return &Cli{migrator: migrator.New()}
}

func (c *Cli) WithPostgre(f func(conn *gorm.DB) []migration.Migration) *Cli {
	c.migrator.WithPostgre(f)
	return c
}

func (c Cli) Run() *cli.App {
	app := cli.NewApp()
	app.Name = "SDK Migration"
	app.Usage = "Command Line Tools for Databases Migration"
	app.UsageText = "command [command options] [arguments...]"
	app.Description = "CLI migration tools"
	app.Version = "v1.0.0"
	app.Commands = []*cli.Command{
		command.New(),
		command.Migrate(*c.migrator),
		command.Rollback(*c.migrator),
		command.Check(*c.migrator),
	}

	if err := app.Run(os.Args); err != nil {
		logrus.StandardLogger().Errorf("Run Error: %+v", err)
	}

	return app
}
