package sdkServer

import (
	"context"
	"time"

	"github.com/gin-gonic/gin"
)

type (
	HealthCheckHook func(ctx context.Context) (int, map[string]map[string]interface{})
	HttpHook        func(gn *gin.Engine)
	httpOptions     struct {
		// Server
		port           int
		gracefulPeriod time.Duration
		env            string

		// Hooks
		register   HttpHook
		beforeRun  HttpHook
		afterRun   HttpHook
		beforeExit HttpHook
		afterExit  HttpHook
	}
	HttpOption interface {
		Apply(o *httpOptions)
	}
)

func defaultHttpOption() httpOptions {
	return httpOptions{
		port:           8090,
		gracefulPeriod: 12 * time.Second,
		register:       nil,
		beforeRun:      nil,
		afterRun:       nil,
		beforeExit:     nil,
		afterExit:      nil,
	}
}

type withHttpPort int

func (w withHttpPort) Apply(o *httpOptions) {
	o.port = int(w)
}

func WithHttpPort(port int) HttpOption {
	return withHttpPort(port)
}

type withHttpGraceFulPeriod time.Duration

func (w withHttpGraceFulPeriod) Apply(o *httpOptions) {
	o.gracefulPeriod = time.Duration(w)
}

func WithHttpGraceFulPeriod(duration time.Duration) HttpOption {
	return withHttpGraceFulPeriod(duration)
}

type withHttpRegister HttpHook

func (w withHttpRegister) Apply(o *httpOptions) {
	o.register = HttpHook(w)
}

func WithHttpRegister(hook HttpHook) HttpOption {
	return withHttpRegister(hook)
}

type withHttpBeforeRun HttpHook

func (w withHttpBeforeRun) Apply(o *httpOptions) {
	o.beforeRun = HttpHook(w)
}

func WithHttpBeforeRun(hook HttpHook) HttpOption {
	return withHttpBeforeRun(hook)
}

type withHttpAfterRun HttpHook

func (w withHttpAfterRun) Apply(o *httpOptions) {
	o.afterRun = HttpHook(w)
}

func WithHttpAfterRun(hook HttpHook) HttpOption {
	return withHttpAfterRun(hook)
}

type withHttpBeforeExit HttpHook

func (w withHttpBeforeExit) Apply(o *httpOptions) {
	o.beforeExit = HttpHook(w)
}

func WithHttpBeforeExit(hook HttpHook) HttpOption {
	return withHttpBeforeExit(hook)
}

type withHttpAfterExit HttpHook

func (w withHttpAfterExit) Apply(o *httpOptions) {
	o.afterExit = HttpHook(w)
}

func WithHttpAfterExit(hook HttpHook) HttpOption {
	return withHttpAfterExit(hook)
}
