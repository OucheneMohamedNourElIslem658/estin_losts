package routers

import (
	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/admin/controllers"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/middlewares"
	"github.com/gin-gonic/gin"
)

type AdminRouter struct {
	Router          *gin.RouterGroup
	adminController *controllers.AdminController
	authMiddlewares *middlewares.AuthorizationMiddlewares
}

func NewAdminRouter(router *gin.RouterGroup) *AdminRouter {
	return &AdminRouter{
		Router:          router,
		adminController: controllers.NewAdminController(),
	}
}

func (ar *AdminRouter) RegisterRoutes() {
	router := ar.Router
	adminController := ar.adminController
	authMiddlewares := ar.authMiddlewares

	authorization := authMiddlewares.Authorization()
	authorizationWithAdminCheck := authMiddlewares.AuthorizationWithAdminCheck()

	router.DELETE("/users/:user_id", authorization, authorizationWithAdminCheck, adminController.DeleteUser)
}