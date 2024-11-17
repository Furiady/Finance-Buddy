package pkgError

import "errors"

var (
	ErrBadRequest          = errors.New("error bad request")
	ErrInternalServerError = errors.New("error internal server error")

	ErrCoinNotEnough = errors.New("error coin not enough")
)
