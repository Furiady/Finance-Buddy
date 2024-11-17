package pkgHelper

import (
	"context"

	"github.com/golang-jwt/jwt/v4"
)

type (
	CustomClaim struct {
		jwt.RegisteredClaims
		UserId *int `json:"userId"`
	}
)

func GenerateJwtToken(ctx context.Context, claims CustomClaim, secret string) (*string, error) {

	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	token, err := tokenClaims.SignedString([]byte(secret))
	if err != nil {
		return nil, err
	}

	return &token, nil
}
