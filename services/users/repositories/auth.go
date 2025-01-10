package repositories

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/oauth"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	gin "github.com/gin-gonic/gin"
	gorm "gorm.io/gorm"
)

type AuthRepository struct {
	database  *gorm.DB
	providers oauth.Providers
}

func NewAuthRepository() *AuthRepository {
	return &AuthRepository{
		database:  database.Instance,
		providers: oauth.Instance,
	}
}

func (ar *AuthRepository) RefreshIdToken(refreshToken string) (idToken *string, apiError *utils.APIError) {
	claims, isValid, err := utils.VerifyRefreshToken(refreshToken)

	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if !isValid {
		return nil, &utils.APIError{
			StatusCode: http.StatusBadRequest,
			Message:    "invalid refresh token",
		}
	}

	database := ar.database

	id, ok := claims["id"].(string)
	if !ok {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    "casting id failed",
		}
	}

	var user models.User
	err = database.Where("id = ?", id).First(&user).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "user not found",
			}
		}
		return nil, &utils.APIError{
			StatusCode: http.StatusBadRequest,
			Message:    err.Error(),
		}
	}

	createdIDToken, err := utils.CreateIdToken(
		user.ID,
		user.IsAdmin,
	)
	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusBadRequest,
			Message:    err.Error(),
		}
	}

	return &createdIDToken, nil
}

func (ar *AuthRepository) OAuth(provider string, successURL string, failureURL string) (result gin.H, apiError *utils.APIError) {
	ok := oauth.IsSupportedProvider(provider)
	if !ok {
		return nil, &utils.APIError{
			StatusCode: http.StatusBadRequest,
			Message:    "provider not supported",
		}
	}
	providers := ar.providers
	oauthConfig := providers[provider].Config

	return gin.H{
		"oauthConfig": oauthConfig,
	}, nil
}

type AuthResponse struct {
	IDToken      string
	RefreshToken string
	Name         string
	ImageURL     string
	Email        string
	IsAdmin      bool
}

func (ar *AuthRepository) OAuthCallback(provider string, code string, context context.Context) (authResponse *AuthResponse, apiError *utils.APIError) {
	ok := oauth.IsSupportedProvider(provider)
	if !ok {
		return nil, &utils.APIError{
			StatusCode: http.StatusBadRequest,
			Message:    "provider not supported",
		}
	}

	authProvider := ar.providers[provider]

	oauthConfig := authProvider.Config
	token, err := oauthConfig.Exchange(context, code)
	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	client := oauthConfig.Client(context, token)
	response, err := client.Get(authProvider.UserInfoURL)
	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}
	defer response.Body.Close()

	userData := gin.H{}
	if err := json.NewDecoder(response.Body).Decode(&userData); err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	user := &models.User{}

	switch provider {
	case "google":
		user.FullName = userData["name"].(string)
		user.Email = userData["email"].(string)
		user.ImageURL =  userData["picture"].(string)
	}

	var database = ar.database

	existingUser := &models.User{}
	err = database.Where("email = ?", user.Email).First(existingUser).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if err == nil {
		existingUser.Email = user.Email
		existingUser.FullName = user.FullName
		existingUser.ImageURL = user.ImageURL
		err = database.Save(existingUser).Error
		if err != nil {
			return nil, &utils.APIError{
				StatusCode: http.StatusInternalServerError,
				Message:    err.Error(),
			}
		}
	}

	if err == gorm.ErrRecordNotFound {
		err = database.Create(&user).Error
		if err != nil {
			return nil, &utils.APIError{
				StatusCode: http.StatusInternalServerError,
				Message:    err.Error(),
			}
		}
		existingUser = user
	}

	createdRefreshToken, err := utils.CreateRefreshToken(existingUser.ID)
	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	createdIDToken, err := utils.CreateIdToken(
		existingUser.ID,
		existingUser.IsAdmin,
	)
	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return &AuthResponse{
		IDToken:      createdIDToken,
		RefreshToken: createdRefreshToken,
		Name:         existingUser.FullName,
		ImageURL:     existingUser.ImageURL,
		Email:        existingUser.Email,
		IsAdmin:      existingUser.IsAdmin,
	}, nil
}
