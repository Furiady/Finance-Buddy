package command

import (
	"math"
	"strings"

	"github.com/Furiady/skripsi/db-migration/dbMigration/handler"
	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/connection"
	"github.com/Furiady/skripsi/db-migration/dbMigration/helper/version"
	"github.com/Furiady/skripsi/db-migration/dbMigration/migrator"
	"github.com/sirupsen/logrus"
	"github.com/urfave/cli/v2"
)

func Migrate(m migrator.Migrator) *cli.Command {
	return &cli.Command{
		Name:  "migrate",
		Usage: "migrate [--types <types>] [--version <version>] [--verbose] [--specific]",
		Flags: []cli.Flag{
			&cli.Uint64Flag{
				Name:     "version",
				Aliases:  []string{"v"},
				Value:    math.MaxUint64,
				Required: false,
			},
			&cli.StringFlag{
				Name:     "types",
				Aliases:  []string{"t"},
				Value:    "mysql,postgre",
				Required: false,
			},
			&cli.BoolFlag{
				Name:     "verbose",
				Required: false,
				Value:    false,
			},
			&cli.BoolFlag{
				Name:     "specific",
				Required: false,
				Value:    false,
			},
		},
		Action: func(c *cli.Context) error {
			logrus.StandardLogger().Info("starting migrations")
			ver := c.Uint64("version")
			verbose := c.Bool("verbose")
			specific := c.Bool("specific")
			types := strings.ToLower(c.String("types"))
			migrationsTypes := strings.Split(types, ",")
			if err := connection.CheckConnection(migrationsTypes); err != nil {
				return err
			}
			return handler.GetHandler().Migrate(m, version.Version(ver), specific, verbose, migrationsTypes...)
		},
	}
}
