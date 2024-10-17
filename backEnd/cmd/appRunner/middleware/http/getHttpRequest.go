package sdkHttpMiddleware

import (
	"github.com/gin-gonic/gin"
)

func GetGinHttpRequestHeader(gCtx *gin.Context, headers ...string) string {
	var value = ""
	for _, header := range headers {
		value = gCtx.Request.Header.Get(header)
		if value != "" {
			break
		}
	}
	return value
}

func GetGinHttpRequestHeaderWithDefault(gCtx *gin.Context, fn func() string, headers ...string) string {
	var value = ""
	for _, header := range headers {
		value = gCtx.Request.Header.Get(header)
		if value != "" {
			break
		}
	}
	if value == "" {
		return fn()
	}
	return value
}
