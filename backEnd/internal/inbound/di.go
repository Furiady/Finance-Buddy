package inbound

import (
	"backEnd/internal/inbound/http"

	"go.uber.org/dig"
)

type Inbound struct {
	dig.In

	http.Http
}
