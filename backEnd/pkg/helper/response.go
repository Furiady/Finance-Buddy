package pkgHelper

import (
	"net/http"

	"github.com/go-playground/validator/v10"
)

func FromErrorStringMap(msg string, errMap map[string]int) int {
	if f, ok := errMap[msg]; ok {
		return f
	}

	return http.StatusInternalServerError
}

func FromErrorMap(err error, errorMap map[error]int) int {
	if f, ok := errorMap[err]; ok {
		return f
	}

	return http.StatusInternalServerError
}

func GetHttpStatusCode(err error, httpStatusMap map[error]int) int {
	if _, ok := err.(validator.ValidationErrors); ok {
		return http.StatusUnprocessableEntity
	}

	if f, ok := httpStatusMap[err]; ok {
		return f
	}

	return http.StatusInternalServerError
}