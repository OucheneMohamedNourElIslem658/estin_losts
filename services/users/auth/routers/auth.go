package routers

import (
	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/users/auth/controllers"
	"github.com/gin-gonic/gin"
)

type AuthRouter struct {
	Router          *gin.RouterGroup
	authController  *controllers.AuthController
}

func NewAuthRouter(router *gin.RouterGroup) *AuthRouter {
	return &AuthRouter{
		Router:          router,
		authController:  controllers.NewAuthController(),
	}
}

func (ar *AuthRouter) RegisterRoutes() {
	router := ar.Router
	authController := ar.authController

	router.GET("/oauth/:provider/login", authController.OAuth)
	router.GET("/oauth/:provider/callback", authController.OAuthCallback)
}
