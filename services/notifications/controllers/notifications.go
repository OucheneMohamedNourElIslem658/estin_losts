package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/notifications/repositories"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/realtime"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"github.com/gin-gonic/gin"
	"github.com/olahol/melody"
)

type NotificationsController struct {
	notificationRepository *repositories.NotificationRepository
	realtime               *realtime.Realtime
	socket                 *melody.Melody
}

func NewNotificationsController() *NotificationsController {
	return &NotificationsController{
		notificationRepository: repositories.NewNotificationRepository(),
		realtime:               realtime.Instance,
		socket:                 melody.New(),
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
	userID := ctx.GetString("id")

	apiError := nc.notificationRepository.UpdateNotification(notificationID, userID, dto)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}

func (nc *NotificationsController) GetUserNotifications(ctx *gin.Context) {
	userID := ctx.GetString("id")

	notificationRepository := nc.notificationRepository

	getNotificationsAsBytes := func() []byte {
		notifications, apiError := notificationRepository.GetUserNotifications(userID)
		if apiError != nil {
			ctx.JSON(apiError.StatusCode, apiError.Message)
		}

		notificationsBytes, err := json.MarshalIndent(notifications, "", "  ")
		if err != nil {
			return nil
		}

		return notificationsBytes
	}

	nc.socket.HandleConnect(func(s *melody.Session) {
		notifications := getNotificationsAsBytes()
		s.Write(notifications)
		nc.realtime.Listen("notifications", func(snapshotType realtime.SnapshotType, payload map[string]interface{}) {
			if payload["user_id"] == userID {
				notifications = getNotificationsAsBytes()
				s.Write(notifications)
			}
		})
	})

	nc.socket.HandleRequest(ctx.Writer, ctx.Request)
}

func (nc *NotificationsController) GetNotificationStatistics(ctx *gin.Context) {
	userID := ctx.GetString("id")

	notificationRepository := nc.notificationRepository

	getNotificationsStatisticsAsBytes := func() []byte {
		notificationsStatistics, apiError := notificationRepository.GetNotificationStatistics(userID)
		if apiError != nil {
			ctx.JSON(apiError.StatusCode, apiError.Message)
		}

		notificationsBytes, err := json.MarshalIndent(notificationsStatistics, "", "  ")
		if err != nil {
			return nil
		}

		return notificationsBytes
	}

	nc.socket.HandleConnect(func(s *melody.Session) {
		notifications := getNotificationsStatisticsAsBytes()
		s.Write(notifications)
		nc.realtime.Listen("notifications", func(snapshotType realtime.SnapshotType, payload map[string]interface{}) {
			if payload["user_id"] == userID {
				notifications = getNotificationsStatisticsAsBytes()
				s.Write(notifications)
			}
		})
	})

	nc.socket.HandleRequest(ctx.Writer, ctx.Request)
}

func (nc *NotificationsController) PushNewNotification(ctx *gin.Context) {
	userID := ctx.GetString("id")

	nc.socket.HandleConnect(func(s *melody.Session) {
		nc.realtime.Listen("notifications", func(snapshotType realtime.SnapshotType, payload map[string]interface{}) {
			if snapshotType == realtime.Insert && payload["user_id"] == userID {
				notificationBytes, err := json.MarshalIndent(payload, "", "  ")
				if err != nil {
					return
				}
				s.Write(notificationBytes)
			}
		})
	})

	nc.socket.HandleRequest(ctx.Writer, ctx.Request)
}