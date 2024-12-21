package utils

import (
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v4"
)

var secretKey = []byte("learn_oo")

func CreateIdToken(id string, isAdmin bool) (string, error) {
	jwtIdToken := jwt.NewWithClaims(
		jwt.SigningMethodHS256,
		jwt.MapClaims{
			"id":       id,
			"is_admin": isAdmin,
			"exp":      time.Now().Add(time.Hour).Unix(),
		},
	)

	idToken, err := jwtIdToken.SignedString(secretKey)
	return idToken, err
}

type Claims struct {
	ID       string
	IsAdmin  bool
}

func VerifyIDToken(idToken string) (claims *Claims, isValid bool, err error) {
	jwtIdToken, err := jwt.Parse(idToken, func(t *jwt.Token) (interface{}, error) {
		return secretKey, nil
	})

	if err != nil {
		return nil, false, err
	}

	if !jwtIdToken.Valid {
		return nil, false, nil
	}

	userClaims := &Claims{}
	jwtClaims, _ := jwtIdToken.Claims.(jwt.MapClaims)

	if id, ok := jwtClaims["id"].(string); !ok {
		return nil, false, errors.New("casting id failed")
	} else {
		userClaims.ID = id
	}

	if isAdmin, ok := jwtClaims["is_admin"].(bool); !ok {
		return nil, false, errors.New("casting is admin failed")
	} else {
		userClaims.IsAdmin = isAdmin
	}

	return userClaims, true, nil
}

func CreateRefreshToken(id string) (string, error) {
	fmt.Println(id)
	jwtIdToken := jwt.NewWithClaims(
		jwt.SigningMethodHS256,
		jwt.MapClaims{
			"id": id,
		},
	)
	idToken, err := jwtIdToken.SignedString(secretKey)
	return idToken, err
}

func VerifyRefreshToken(refreshToken string) (jwt.MapClaims, error) {
	jwtRefreshToken, err := jwt.Parse(refreshToken, func(t *jwt.Token) (interface{}, error) {
		return secretKey, nil
	})

	if err != nil {
		return nil, err
	}

	if !jwtRefreshToken.Valid {
		return nil, errors.New("invalid refresh token")
	}

	claims, _ := jwtRefreshToken.Claims.(jwt.MapClaims)

	return claims, nil
}
