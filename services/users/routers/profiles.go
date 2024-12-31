package routers

import (
	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/users/controllers"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/middlewares"
	"github.com/gin-gonic/gin"
)

type ProfilesRouter struct {
	Router             *gin.RouterGroup
	profilesController *controllers.ProfilesController
	authMiddlewares    *middlewares.AuthorizationMiddlewares
}

func NewProfilesRouter(router *gin.RouterGroup) *ProfilesRouter {
	return &ProfilesRouter{
		Router:             router,
		profilesController: controllers.NewProfilesController(),
		authMiddlewares:    middlewares.NewAuthorizationMiddlewares(),
	}
}

func (pr *ProfilesRouter) RegisterRoutes() {
	router := pr.Router
	profilesController := pr.profilesController

	authMiddlewares := pr.authMiddlewares
	authorization := authMiddlewares.Authorization()
	authorizationWithUserCheck := authMiddlewares.AuthorizationWithUserCheck()

	router.GET("/profile", authorization, authorizationWithUserCheck, profilesController.GetProfile)
	router.GET("/users/:user_id", authorization, authorizationWithUserCheck, profilesController.GetUser)
}
