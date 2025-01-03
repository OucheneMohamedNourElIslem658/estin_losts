package controllers

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/notifications/repositories"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"github.com/gin-gonic/gin"
)

type NotificationsController struct {
	notificationRepository *repositories.NotificationRepository
}

func NewNotificationsController() *NotificationsController {
	return &NotificationsController{
		notificationRepository: repositories.NewNotificationRepository(),
	}
}

func (nc *NotificationsController) UpdateNotification(ctx *gin.Context) {
	var dto repositories.NotificationDTO
	if err := ctx.ShouldBind(&dto); err != nil {
		message := utils.ValidationErrorResponse(err, dto)
		ctx.JSON(http.StatusBadRequest, message)
		return
	}

	notificationID := ctx.Param("notification_id")
	userID := ctx.GetString("user_id")

	apiError := nc.notificationRepository.UpdateNotification(notificationID, userID, dto)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}