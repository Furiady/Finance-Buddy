package sdkHttpMiddleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	sdkMiddleware "backEnd/cmd/appRunner/middleware"
	sdkMandatory "backEnd/cmd/appRunner/mandatory"
)

const (
	TraceID       = "Trace-Id"
	Language      = "Lang"
	AppVersion    = "App-Version"
	ServiceID     = "Serviceid"
	ServiceSecret = "Servicesecret"
	Authorization = "Authorization"
	ApiKey        = "API-Key"
	DeviceID      = "Device-Id"
	DeviceType    = "Device-Type"
	UserAgent     = "User-Agent"
	IpAddress     = "X-Forwarded-For"

	XTraceID       = "X-Trace-Id"
	XAppVersion    = "X-App-Version"
	XServiceID     = "Service-Id"
	XServiceSecret = "Service-Secret"
	XApiKey        = "Api-Key"
)

func AppContextGin() gin.HandlerFunc {
	return func(gCtx *gin.Context) {
		builder, err := sdkMandatory.NewMandatoryBuilder()
		if err != nil {
			gCtx.JSON(http.StatusInternalServerError, map[string]interface{}{"error": err.Error()})
			return
		}

		mandatory := ginHttpMandatoryBuilder(gCtx, builder).Build()
		ctx := sdkMandatory.Context(gCtx.Request.Context(), mandatory)
		gCtx.Request = gCtx.Request.WithContext(ctx)
		gCtx.Next()
	}
}

func ginHttpMandatoryBuilder(gCtx *gin.Context, builder sdkMandatory.MandatoryBuilder) sdkMandatory.MandatoryBuilder {
	mandatoryBuilder := builder.
		WithTraceID(GetGinHttpRequestHeaderWithDefault(gCtx, sdkMiddleware.GenerateUUID, TraceID, XTraceID)).
		WithDeviceType(GetGinHttpRequestHeaderWithDefault(gCtx, sdkMiddleware.EmptyString, DeviceType)).
		WithAuthorization(GetGinHttpRequestHeader(gCtx, Authorization)).
		WithLanguage(GetGinHttpRequestHeader(gCtx, Language)).
		WithApiKey(GetGinHttpRequestHeader(gCtx, ApiKey, XApiKey)).
		WithIpAddresses(strings.Split(GetGinHttpRequestHeader(gCtx, IpAddress), ",")).
		WithUserAgent(GetGinHttpRequestHeader(gCtx, UserAgent)).
		WithServiceSecret(
			GetGinHttpRequestHeader(gCtx, ServiceID, XServiceID),
			GetGinHttpRequestHeader(gCtx, ServiceSecret, XServiceSecret),
		)

	appsVersion := GetGinHttpRequestHeader(gCtx, AppVersion, XAppVersion)
	deviceID := GetGinHttpRequestHeader(gCtx, DeviceID)
	if deviceID != "" || appsVersion != "" {
		mandatoryBuilder = mandatoryBuilder.WithApplication(deviceID, appsVersion)
	}
	return mandatoryBuilder
}
