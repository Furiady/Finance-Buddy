package common

import (
	pkgError "backEnd/pkg/constant/error"
	"net/http"
)

var (
	ErrorMap = map[error]int{
		pkgError.ErrBadRequest:          http.StatusBadRequest,
		pkgError.ErrInternalServerError: http.StatusInternalServerError,
	}
)
