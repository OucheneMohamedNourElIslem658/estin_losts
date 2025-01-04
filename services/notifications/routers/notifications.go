package routers

import (
	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/notifications/controllers"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/middlewares"
	"github.com/gin-gonic/gin"
)

type NotificationsRouter struct {
	Router                   *gin.RouterGroup
	notificationController   *controllers.NotificationsController
	authorizationMiddlewares *middlewares.AuthorizationMiddlewares
}

func NewNotificationsRouter(router *gin.RouterGroup) *NotificationsRouter {
	return &NotificationsRouter{
		Router:                   router,
		authorizationMiddlewares: middlewares.NewAuthorizationMiddlewares(),
		notificationController:   controllers.NewNotificationsController(),
	}
}

func (nc *NotificationsRouter) RegisterRoutes() {
	router := nc.Router
	notificationController := nc.notificationController

	authorization := nc.authorizationMiddlewares.Authorization()
	authorizationWithUserCheck := nc.authorizationMiddlewares.AuthorizationWithUserCheck()

	router.PUT("/:notification_id", authorization, authorizationWithUserCheck, notificationController.UpdateNotification)
	router.GET("/snapshot", authorization, authorizationWithUserCheck, notificationController.GetUserNotifications)
	router.GET("/statistics/snapshot", authorization, authorizationWithUserCheck, notificationController.GetNotificationStatistics)
	router.GET("/new/snapshot", authorization, authorizationWithUserCheck, notificationController.PushNewNotification)
}
