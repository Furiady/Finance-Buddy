package httpMiddleware

import (
	"context"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"

	strictgin "github.com/oapi-codegen/runtime/strictmiddleware/gin"
)

func ValidateToken(env string, secret string) strictgin.StrictGinMiddlewareFunc {
	return func(f strictgin.StrictGinHandlerFunc, operationID string) strictgin.StrictGinHandlerFunc {
		return func(c *gin.Context, request interface{}) (response interface{}, err error) {
			authHeader := c.GetHeader("Authorization")
			if authHeader == "" {
				c.JSON(http.StatusUnauthorized, gin.H{
					"status":  "fail",
					"message": "Unauthorized",
				})
				c.Abort()
				return
			}

			token, err := jwt.Parse(authHeader, func(token *jwt.Token) (interface{}, error) {
				return []byte(secret), nil
			})
			if err != nil || !token.Valid {
				c.JSON(http.StatusUnauthorized, gin.H{
					"status":  "fail",
					"message": "Unauthorized",
				})
				c.Abort()
				return
			}

			claims, isValid := token.Claims.(jwt.MapClaims)
			if !isValid || !token.Valid {
				c.JSON(http.StatusUnauthorized, gin.H{
					"status":  "fail",
					"message": "Invalid token",
				})
				c.Abort()
				return
			}

			if err = claims.Valid(); err != nil {
				c.JSON(http.StatusUnauthorized, gin.H{
					"status":  "fail",
					"message": "Invalid token claims",
				})
				c.Abort()
				return
			}

			if claims["userId"] == 0 || claims["userId"] == nil {
				c.JSON(http.StatusUnauthorized, gin.H{
					"status":  "fail",
					"message": "Invalid token username",
				})
				c.Abort()
				return
			}

			userId := int(claims["userId"].(float64))
			ctx := c.Request.Context()
			ctx = context.WithValue(ctx, "userId", strconv.Itoa(int(userId)))
			ctx = context.WithValue(ctx, "token", token)

			c.Set("userId", strconv.Itoa(int(userId)))
			c.Request = c.Request.WithContext(ctx)
			return f(c, request)
		}
	}
}
