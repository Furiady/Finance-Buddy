// Package pet provides primitives to interact with the openapi HTTP API.
//
// Code generated by github.com/deepmap/oapi-codegen/v2 version v2.1.0 DO NOT EDIT.
package pet

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	externalRef0 "backEnd/internal/inbound/http/v1/common"

	"github.com/gin-gonic/gin"
	"github.com/oapi-codegen/runtime"
	strictgin "github.com/oapi-codegen/runtime/strictmiddleware/gin"
)

// BuyPetJSONBody defines parameters for BuyPet.
type BuyPetJSONBody struct {
	PetId string `json:"petId"`
}

// BuyPetParams defines parameters for BuyPet.
type BuyPetParams struct {
	Authorization string `json:"Authorization"`
}

// GetAllParams defines parameters for GetAll.
type GetAllParams struct {
	Authorization string `json:"Authorization"`
}

// BuyPetJSONRequestBody defines body for BuyPet for application/json ContentType.
type BuyPetJSONRequestBody BuyPetJSONBody

// ServerInterface represents all server handlers.
type ServerInterface interface {

	// (POST /pet)
	BuyPet(c *gin.Context, params BuyPetParams)
	// Your GET endpoint
	// (GET /pets)
	GetAll(c *gin.Context, params GetAllParams)
}

// ServerInterfaceWrapper converts contexts to parameters.
type ServerInterfaceWrapper struct {
	Handler            ServerInterface
	HandlerMiddlewares []MiddlewareFunc
	ErrorHandler       func(*gin.Context, error, int)
}

type MiddlewareFunc func(c *gin.Context)

// BuyPet operation middleware
func (siw *ServerInterfaceWrapper) BuyPet(c *gin.Context) {

	var err error

	// Parameter object where we will unmarshal all parameters from the context
	var params BuyPetParams

	headers := c.Request.Header

	// ------------- Required header parameter "Authorization" -------------
	if valueList, found := headers[http.CanonicalHeaderKey("Authorization")]; found {
		var Authorization string
		n := len(valueList)
		if n != 1 {
			siw.ErrorHandler(c, fmt.Errorf("Expected one value for Authorization, got %d", n), http.StatusBadRequest)
			return
		}

		err = runtime.BindStyledParameterWithOptions("simple", "Authorization", valueList[0], &Authorization, runtime.BindStyledParameterOptions{ParamLocation: runtime.ParamLocationHeader, Explode: false, Required: true})
		if err != nil {
			siw.ErrorHandler(c, fmt.Errorf("Invalid format for parameter Authorization: %w", err), http.StatusBadRequest)
			return
		}

		params.Authorization = Authorization

	} else {
		siw.ErrorHandler(c, fmt.Errorf("Header parameter Authorization is required, but not found"), http.StatusBadRequest)
		return
	}

	for _, middleware := range siw.HandlerMiddlewares {
		middleware(c)
		if c.IsAborted() {
			return
		}
	}

	siw.Handler.BuyPet(c, params)
}

// GetAll operation middleware
func (siw *ServerInterfaceWrapper) GetAll(c *gin.Context) {

	var err error

	// Parameter object where we will unmarshal all parameters from the context
	var params GetAllParams

	headers := c.Request.Header

	// ------------- Required header parameter "Authorization" -------------
	if valueList, found := headers[http.CanonicalHeaderKey("Authorization")]; found {
		var Authorization string
		n := len(valueList)
		if n != 1 {
			siw.ErrorHandler(c, fmt.Errorf("Expected one value for Authorization, got %d", n), http.StatusBadRequest)
			return
		}

		err = runtime.BindStyledParameterWithOptions("simple", "Authorization", valueList[0], &Authorization, runtime.BindStyledParameterOptions{ParamLocation: runtime.ParamLocationHeader, Explode: false, Required: true})
		if err != nil {
			siw.ErrorHandler(c, fmt.Errorf("Invalid format for parameter Authorization: %w", err), http.StatusBadRequest)
			return
		}

		params.Authorization = Authorization

	} else {
		siw.ErrorHandler(c, fmt.Errorf("Header parameter Authorization is required, but not found"), http.StatusBadRequest)
		return
	}

	for _, middleware := range siw.HandlerMiddlewares {
		middleware(c)
		if c.IsAborted() {
			return
		}
	}

	siw.Handler.GetAll(c, params)
}

// GinServerOptions provides options for the Gin server.
type GinServerOptions struct {
	BaseURL      string
	Middlewares  []MiddlewareFunc
	ErrorHandler func(*gin.Context, error, int)
}

// RegisterHandlers creates http.Handler with routing matching OpenAPI spec.
func RegisterHandlers(router gin.IRouter, si ServerInterface) {
	RegisterHandlersWithOptions(router, si, GinServerOptions{})
}

// RegisterHandlersWithOptions creates http.Handler with additional options
func RegisterHandlersWithOptions(router gin.IRouter, si ServerInterface, options GinServerOptions) {
	errorHandler := options.ErrorHandler
	if errorHandler == nil {
		errorHandler = func(c *gin.Context, err error, statusCode int) {
			c.JSON(statusCode, gin.H{"msg": err.Error()})
		}
	}

	wrapper := ServerInterfaceWrapper{
		Handler:            si,
		HandlerMiddlewares: options.Middlewares,
		ErrorHandler:       errorHandler,
	}

	router.POST(options.BaseURL+"/pet", wrapper.BuyPet)
	router.GET(options.BaseURL+"/pets", wrapper.GetAll)
}

type BuyPetRequestObject struct {
	Params BuyPetParams
	Body   *BuyPetJSONRequestBody
}

type BuyPetResponseObject interface {
	VisitBuyPetResponse(w http.ResponseWriter) error
}

type BuyPet200JSONResponse externalRef0.BaseResponse

func (response BuyPet200JSONResponse) VisitBuyPetResponse(w http.ResponseWriter) error {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(200)

	return json.NewEncoder(w).Encode(response)
}

type BuyPetdefaultJSONResponse struct {
	Body       externalRef0.BaseResponse
	StatusCode int
}

func (response BuyPetdefaultJSONResponse) VisitBuyPetResponse(w http.ResponseWriter) error {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(response.StatusCode)

	return json.NewEncoder(w).Encode(response.Body)
}

type GetAllRequestObject struct {
	Params GetAllParams
}

type GetAllResponseObject interface {
	VisitGetAllResponse(w http.ResponseWriter) error
}

type GetAll200JSONResponse []externalRef0.Pet

func (response GetAll200JSONResponse) VisitGetAllResponse(w http.ResponseWriter) error {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(200)

	return json.NewEncoder(w).Encode(response)
}

type GetAlldefaultJSONResponse struct {
	Body       externalRef0.BaseResponse
	StatusCode int
}

func (response GetAlldefaultJSONResponse) VisitGetAllResponse(w http.ResponseWriter) error {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(response.StatusCode)

	return json.NewEncoder(w).Encode(response.Body)
}

// StrictServerInterface represents all server handlers.
type StrictServerInterface interface {

	// (POST /pet)
	BuyPet(ctx context.Context, request BuyPetRequestObject) (BuyPetResponseObject, error)
	// Your GET endpoint
	// (GET /pets)
	GetAll(ctx context.Context, request GetAllRequestObject) (GetAllResponseObject, error)
}

type StrictHandlerFunc = strictgin.StrictGinHandlerFunc
type StrictMiddlewareFunc = strictgin.StrictGinMiddlewareFunc

func NewStrictHandler(ssi StrictServerInterface, middlewares []StrictMiddlewareFunc) ServerInterface {
	return &strictHandler{ssi: ssi, middlewares: middlewares}
}

type strictHandler struct {
	ssi         StrictServerInterface
	middlewares []StrictMiddlewareFunc
}

// BuyPet operation middleware
func (sh *strictHandler) BuyPet(ctx *gin.Context, params BuyPetParams) {
	var request BuyPetRequestObject

	request.Params = params

	var body BuyPetJSONRequestBody
	if err := ctx.ShouldBindJSON(&body); err != nil {
		ctx.Status(http.StatusBadRequest)
		ctx.Error(err)
		return
	}
	request.Body = &body

	handler := func(ctx *gin.Context, request interface{}) (interface{}, error) {
		return sh.ssi.BuyPet(ctx, request.(BuyPetRequestObject))
	}
	for _, middleware := range sh.middlewares {
		handler = middleware(handler, "BuyPet")
	}

	response, err := handler(ctx, request)

	if err != nil {
		ctx.Error(err)
		ctx.Status(http.StatusInternalServerError)
	} else if validResponse, ok := response.(BuyPetResponseObject); ok {
		if err := validResponse.VisitBuyPetResponse(ctx.Writer); err != nil {
			ctx.Error(err)
		}
	} else if response != nil {
		ctx.Error(fmt.Errorf("unexpected response type: %T", response))
	}
}

// GetAll operation middleware
func (sh *strictHandler) GetAll(ctx *gin.Context, params GetAllParams) {
	var request GetAllRequestObject

	request.Params = params

	handler := func(ctx *gin.Context, request interface{}) (interface{}, error) {
		return sh.ssi.GetAll(ctx, request.(GetAllRequestObject))
	}
	for _, middleware := range sh.middlewares {
		handler = middleware(handler, "GetAll")
	}

	response, err := handler(ctx, request)

	if err != nil {
		ctx.Error(err)
		ctx.Status(http.StatusInternalServerError)
	} else if validResponse, ok := response.(GetAllResponseObject); ok {
		if err := validResponse.VisitGetAllResponse(ctx.Writer); err != nil {
			ctx.Error(err)
		}
	} else if response != nil {
		ctx.Error(fmt.Errorf("unexpected response type: %T", response))
	}
}
