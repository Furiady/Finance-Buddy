package command

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"database/dbMigration/handler"
	"database/dbMigration/helper/connection"
	"database/dbMigration/helper/version"

	"github.com/pkg/errors"
	"github.com/sirupsen/logrus"
	"github.com/urfave/cli/v2"
)

func New() *cli.Command {
	return &cli.Command{
		Name:  "new",
		Usage: "new --types <type> --name <name>",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:     "types",
				Aliases:  []string{"t"},
				Required: true,
			},
			&cli.StringFlag{
				Name:     "name",
				Aliases:  []string{"n"},
				Required: true,
			},
		},
		Action: func(c *cli.Context) error {

			migrationType := strings.TrimSpace(strings.ToLower(c.String("types")))
			migrationName := strings.TrimSpace(strings.ToLower(c.String("name")))

			if len(migrationName) < 1 {
				return errors.New("migration name is required")
			}

			if strings.Index(migrationName, "test") == len(migrationName)-4 {
				return errors.New("migration name must not ended with \"test\"")
			}

			if !connection.IsValid(migrationType) {
				return errors.New("invalid migration type [mysql | postgre]")
			}

			logrus.StandardLogger().Infof("start creating new %s migrations file", migrationType)

			now := time.Now()
			year, month, date := now.Date()
			hour := now.Hour()
			minute := now.Minute()
			second := now.Second()

			var stringVersion = fmt.Sprintf("%04d%02d%02d%02d%02d%02d",
				year, month, date, hour, minute, second)
			ver, err := strconv.ParseUint(stringVersion, 10, 64)
			if err != nil {
				return err
			}

			return handler.GetHandler().New(version.Version(ver), migrationType, migrationName)
		},
	}
}
