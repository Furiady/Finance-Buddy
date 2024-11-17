package auth

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Logout implements StrictServerInterface.
func (c *Controller) Logout(ctx context.Context, request LogoutRequestObject) (LogoutResponseObject, error) {
	cookie := http.Cookie{
		Name:     "token",
		Value:    "emptyCookie",
		MaxAge:   1,
		HttpOnly: true,
		Secure:   true,
		Path:     "/",
	}
	ctx.(*gin.Context).SetCookie(cookie.Name, cookie.Value, cookie.MaxAge, cookie.Path, cookie.Domain, cookie.Secure, cookie.HttpOnly)

	return Logout204Response{}, nil
}
