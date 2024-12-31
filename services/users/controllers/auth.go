package controllers

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/users/repositories"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
)

type AuthController struct {
	authRepository *repositories.AuthRepository
}

func NewAuthController() *AuthController {
	return &AuthController{
		authRepository: repositories.NewAuthRepository(),
	}
}

func (authcontroller *AuthController) RefreshIdToken(ctx *gin.Context) {
	authorization := ctx.GetHeader("Authorization")

	if authorization == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"error": "missing authorization header",
		})
		return

	}

	refreshToken := authorization[len("Bearer "):]

	if refreshToken == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"error": "missing refresh token",
		})
		return
	}

	repository := authcontroller.authRepository

	if idToken, err := repository.RefreshIdToken(refreshToken); err != nil {
		ctx.JSON(err.StatusCode, gin.H{
			"error": err.Message,
		})
	} else {
		ctx.SetCookie("id_token", *idToken, 3600, "/", "", false, true)
		ctx.JSON(http.StatusOK, nil)
	}
}

func (authcontroller *AuthController) OAuth(ctx *gin.Context) {
	var query struct {
		SuccessUrl string `form:"success_url" json:"success_url" binding:"required"`
		FailureUrl string `form:"failure_url" json:"failure_url" binding:"required"`
	}

	if err := ctx.ShouldBindQuery(&query); err != nil {
		message := utils.ValidationErrorResponse(err, query)
		ctx.JSON(http.StatusBadRequest, message)
		return
	}

	provider := ctx.Param("provider")

	authRepository := authcontroller.authRepository
	if result, err := authRepository.OAuth(provider, query.SuccessUrl, query.FailureUrl); err != nil {
		ctx.JSON(err.StatusCode, gin.H{
			"error": err.Message,
		})
	} else {
		oauthConfig := result["oauthConfig"].(*oauth2.Config)
		queryBytes, _ := json.Marshal(&query)
		url := oauthConfig.AuthCodeURL(string(queryBytes), oauth2.AccessTypeOffline)
		ctx.Redirect(http.StatusTemporaryRedirect, url)
	}
}

func (authcontroller *AuthController) OAuthCallback(ctx *gin.Context) {
	provider := ctx.Param("provider")

	var metadata struct {
		SuccessURL string `json:"success_url"`
		FailureURL string `json:"failure_url"`
	}
	code := ctx.Query("code")
	state := ctx.Query("state")
	json.Unmarshal([]byte(state), &metadata)

	authRepository := authcontroller.authRepository

	if idToken, refreshToken, err := authRepository.OAuthCallback(provider, code, ctx.Request.Context()); err != nil {
		failureURL := fmt.Sprintf("%v?message=%v", metadata.FailureURL, err.Message)
		ctx.Redirect(http.StatusTemporaryRedirect, failureURL)
	} else {
		successURL := fmt.Sprintf("%v?id_token=%v&refresh_token=%v", metadata.SuccessURL, *idToken, *refreshToken)
		ctx.Redirect(http.StatusTemporaryRedirect, successURL)
	}
}
