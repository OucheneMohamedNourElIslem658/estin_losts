package repositories

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"gorm.io/gorm"
)

type NotificationRepository struct {
	database *gorm.DB
}

func NewNotificationRepository() *NotificationRepository {
	return &NotificationRepository{
		database: database.Instance,
	}
}

func (r *NotificationRepository) AddNotification(notification models.Notification) (err error) {
	err = r.database.Create(&notification).Error
	return
}

func (r *NotificationRepository) AddPostCreationNotification(post models.Post) (err error) {
	err = r.database.Exec(`
		INSERT INTO notifications (user_id, post_id, tag, created_at, updated_at)
		SELECT user_id, ?, ?, NOW(), NOW()
		FROM users
		WHERE user_id != ?
	`, post.ID, models.PostCreated, post.UserID).Error

	if err != nil {
		return err
	}

	return
}

func (r *NotificationRepository) AddFoundAddedNotification(post models.Post) (err error) {
	err = r.database.Exec(`
		INSERT INTO notifications (user_id, post_id, tag, created_at, updated_at)
		VALUES (?, ?, ?, NOW(), NOW())
	`, post.UserID, post.ID, models.FoundAdded).Error

	if err != nil {
		return err
	}

	return
}

func (r *NotificationRepository) AddClaimAddedNotification(post models.Post) (err error) {
	err = r.database.Exec(`
		INSERT INTO notifications (user_id, post_id, tag, created_at, updated_at)
		VALUES (?, ?, ?, NOW(), NOW())
	`, post.UserID, post.ID, models.ClaimAdded).Error

	if err != nil {
		return err
	}

	return
}

func (r *NotificationRepository) AddObjectFoundNotification(post models.Post) (err error) {
	err = r.database.Exec(`
		INSERT INTO notifications (user_id, post_id, tag, created_at, updated_at)
		SELECT user_id, ?, ?, NOW(), NOW()
		FROM founds
		WHERE post_id = ? AND user_id != ?
	`, post.ID, models.ObjectFound, post.ID, post.UserID).Error

	return
}

func (r *NotificationRepository) AddObjectDeliveredNotification(post models.Post) (err error) {
	err = r.database.Exec(`
		INSERT INTO notifications (user_id, post_id, tag, created_at, updated_at)
		SELECT user_id, ?, ?, NOW(), NOW()
		FROM claims
		WHERE post_id = ? AND user_id != ?
	`, post.ID, models.ObjectDelivered, post.ID, post.UserID).Error

	return
}

func (r *NotificationRepository) GetUserNotifications(userID string) (userNotification []models.Notification, apiError *utils.APIError) {
	err := r.database.Where("user_id = ?", userID).Find(&userNotification).Error
	if err != nil {
		return userNotification, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}
	return
}

type NotificationDTO struct {
	Seen bool `json:"seen" binding:"required"`
}

func (r *NotificationRepository) UpdateNotification(notificationID string, notification NotificationDTO) (apiError *utils.APIError) {
	err := r.database.Model(&models.Notification{}).Where("id = ?", notificationID).Update("seen", notification.Seen).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}
	return
}

type NotificationStatistics struct {
	TotalNotificationsCount  int `json:"total_notifications_count"`
	UnseenNotificationsCount int `json:"unseen_notifications_count"`
}

func (r *NotificationRepository) GetNotificationStatistics(notificationID string) (notificationStatistics NotificationStatistics, apiError *utils.APIError) {
	err := r.database.Model(&models.Notification{}).Where("user_id = ?", notificationID).
		Select("count(*) as total_notifications_count, sum(case when seen = false then 1 else 0 end) as unseen_notifications_count").
		Scan(&notificationStatistics).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return notificationStatistics, &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "notification not found",
			}
		}
		return notificationStatistics, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}
	return
}
