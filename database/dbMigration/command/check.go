package command

import (
	"strings"

	"database/dbMigration/handler"
	"database/dbMigration/helper/version"
	"database/dbMigration/migrator"

	"github.com/sirupsen/logrus"
	"github.com/urfave/cli/v2"
)

func Check(m migrator.Migrator) *cli.Command {
	return &cli.Command{
		Name:  "check",
		Usage: "check [--types <types>] [--version <version>]",
		Flags: []cli.Flag{
			&cli.Uint64Flag{
				Name:     "version",
				Aliases:  []string{"v"},
				Required: false,
			},
			&cli.StringFlag{
				Name:     "types",
				Aliases:  []string{"t"},
				Value:    "mysql,postgre",
				Required: false,
			},
		},
		Action: func(c *cli.Context) error {
			logrus.StandardLogger().Info("checking migrations...")
			ver := c.Uint64("version")
			types := strings.ToLower(c.String("types"))
			migrationTypes := strings.Split(types, ",")
			return handler.GetHandler().Check(m, version.Version(ver), migrationTypes...)
		},
	}
}
