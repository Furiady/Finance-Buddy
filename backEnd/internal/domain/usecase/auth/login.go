package auth

import (
	"backEnd/internal/domain/model"
	obModel "backEnd/internal/outbound/model"
	pkgError "backEnd/pkg/constant/error"
	pkgHelper "backEnd/pkg/helper"
	"context"
	"net/http"
	"time"

	"github.com/golang-jwt/jwt/v4"
)

// Login implements UseCase.
func (u *useCase) Login(ctx context.Context, request model.LoginRequest) (*http.Cookie, error) {
	user, err := u.outbound.Repositories.User.Get(ctx, obModel.RequestGetUser{
		Username: &request.Username,
	})
	if err != nil {
		return nil, err
	}

	if user.Id == 0 {
		return nil, pkgError.ErrBadRequest
	}

	if user.Password != request.Password {
		return nil, pkgError.ErrBadRequest
	}

	claims := pkgHelper.CustomClaim{
		UserId: &user.Id,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().AddDate(0, 1, 0).Truncate(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token, err := pkgHelper.GenerateJwtToken(ctx, claims, u.resource.ConfigApp.TokenSecret)
	if err != nil {
		return nil, err
	}

	return &http.Cookie{
		Name:     "token",
		Value:    *token,
		MaxAge:   60 * 60 * 24 * 30,
		HttpOnly: true,
		Secure:   true,
		Path:     "/",
		SameSite: http.SameSiteNoneMode,
	}, nil
}
