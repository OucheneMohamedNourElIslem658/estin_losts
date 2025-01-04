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

func (r *NotificationRepository) AddPostCreationNotification(post models.Post) (err error) {
	err = r.database.Exec(`
		INSERT INTO notifications (id, user_id, post_id, tag, created_at)
		SELECT uuid_generate_v4(), id, ?, ?, NOW()
		FROM users
		WHERE id != ?
	`, post.ID, models.PostCreated, post.UserID).Error

	if err != nil {
		return err
	}

	return
}

func (r *NotificationRepository) AddFoundAddedNotification(post models.Post) (err error) {
	err = r.database.Create(&models.Notification{
		UserID: post.UserID,
		PostID: post.ID,
		Tag:    models.FoundAdded,
	}).Error

	if err != nil {
		return err
	}

	return
}

func (r *NotificationRepository) AddClaimAddedNotification(post models.Post) (err error) {
	err = r.database.Create(&models.Notification{
		UserID: post.UserID,
		PostID: post.ID,
		Tag:    models.ClaimAdded,
	}).Error

	if err != nil {
		return err
	}

	return
}

func (r *NotificationRepository) AddObjectFoundNotification(post models.Post) (err error) {
	err = r.database.Exec(`
		INSERT INTO notifications (id, user_id, post_id, tag, created_at)
		SELECT uuid_generate_v4(), user_id, ?, ?, NOW()
		FROM founds
		WHERE post_id = ? AND user_id != ?
	`, post.ID, models.ObjectFound, post.ID, post.UserID).Error

	return
}

func (r *NotificationRepository) AddObjectDeliveredNotification(post models.Post) (err error) {
	err = r.database.Exec(`
		INSERT INTO notifications (id, user_id, post_id, tag, created_at)
		SELECT uuid_generate_v4(), user_id, ?, ?, NOW()
		FROM claims
		WHERE post_id = ? AND user_id != ?
	`, post.ID, models.ObjectDelivered, post.ID, post.UserID).Error

	return
}

func (r *NotificationRepository) GetNotification(notificationID string) (notification *models.Notification, apiError *utils.APIError) {
	err := r.database.Where("id = ?", notificationID).
		Preload("User").Preload("Post").
		First(notification).
		Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message: "notification not found",
			}
		}

		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message: err.Error(),
		}
	}

	return notification, nil
}

func (r *NotificationRepository) GetUserNotifications(userID string) (userNotification []models.Notification, apiError *utils.APIError) {
	err := r.database.Where("user_id = ?", userID).
	    Preload("User").Preload("Post").
	    Find(&userNotification).
	    Error

	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}
	return userNotification, nil
}

type NotificationDTO struct {
	Seen *bool `json:"seen" binding:"required"`
}

func (r *NotificationRepository) UpdateNotification(notificationID, userID string, notification NotificationDTO) (apiError *utils.APIError) {
	err := r.database.Model(&models.Notification{}).Where("id = ? AND user_id = ?", notificationID, userID).
	    Update("seen", *notification.Seen).
		Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "notification not found",
			}
		}
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

func (r *NotificationRepository) GetNotificationStatistics(userID string) (notificationStatistics NotificationStatistics, apiError *utils.APIError) {
	err := r.database.Model(&models.Notification{}).Where("user_id = ?", userID).
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
