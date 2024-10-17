package sdkServer

import (
	"os"
)

type (
	ServeParam struct {
		Serve     func(sig chan os.Signal)
		Register  func()
		BeforeRun func()
		AfterRun  func()
	}
	ShutdownParam struct {
		Shutdown   func()
		BeforeExit func()
		AfterExit  func()
	}
	ServerTemplate struct{}
)

func (s ServerTemplate) Serve(sig chan os.Signal, param ServeParam) {
	param.Register()
	param.BeforeRun()
	param.Serve(sig)
	param.AfterRun()
}

func (s ServerTemplate) Shutdown(param ShutdownParam) {
	param.BeforeExit()
	param.Shutdown()
	param.AfterExit()
}
