package connection

import (
	"fmt"

	"github.com/pkg/errors"
)

const (
	Postgre = "postgre"
)

func CheckConnection(connections []string) error {
	for _, connection := range connections {
		if !IsValid(connection) {
			return errors.New(fmt.Sprintf("%s is not valid", connection))
		}
	}
	return nil
}

func IsValid(conn string) bool {
	return Postgre == conn
}
