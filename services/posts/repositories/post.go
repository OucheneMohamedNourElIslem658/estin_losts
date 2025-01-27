package repositories

import (
	"fmt"
	"mime/multipart"
	"net/http"
	"strings"
	"time"

	notificationsRepositories "github.com/OucheneMohamedNourElIslem658/estin_losts/services/notifications/repositories"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	filestorage "github.com/OucheneMohamedNourElIslem658/estin_losts/shared/file_storage"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"gorm.io/gorm"
)

type PostRepository struct {
	database               *gorm.DB
	filestorage            *filestorage.FileStorage
	notificationRepository *notificationsRepositories.NotificationRepository
}

func NewPostRepository() *PostRepository {
	return &PostRepository{
		database:               database.Instance,
		filestorage:            filestorage.Instance,
		notificationRepository: notificationsRepositories.NewNotificationRepository(),
	}
}

type CreatePostDTO struct {
	Title             string                  `form:"title" binding:"required"`
	Description       string                  `form:"description"`
	Time              *time.Time              `form:"time" binding:"omitempty,object_time"`
	LocationLatitude  *float64                `form:"location_latitude" binding:"omitempty,required_with=LocationLongitude,min=-90,max=90"`
	LocationLongitude *float64                `form:"location_longitude" binding:"omitempty,required_with=LocationLatitude,min=-180,max=180"`
	Type              string                  `form:"type" binding:"required,oneof=lost found"`
	Images            []*multipart.FileHeader `form:"images" binding:"max=3,dive,image"`
}

func (pr *PostRepository) CreatePost(userID string, dto CreatePostDTO) (apiError *utils.APIError) {
	database := pr.database

	filestorage := filestorage.Instance

	images, err := filestorage.UploadFiles(dto.Images, "posts", nil)
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	postToCreate := models.Post{
		Title:             dto.Title,
		Description:       &dto.Description,
		Time:              dto.Time,
		LocationLatitude:  dto.LocationLatitude,
		LocationLongitude: dto.LocationLongitude,
		Type:              models.PostType(dto.Type),
		UserID:            userID,
		Images:            images,
	}

	err = database.Create(&postToCreate).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	pr.notificationRepository.AddPostCreationNotification(postToCreate)

	return nil
}

type UpdatePostDTO struct {
	Type             string `form:"type" binding:"omitempty,oneof=lost found"`
	HasBeenFound     *bool  `json:"has_been_found"`
	HasBeenDelivered *bool  `json:"has_been_delivered"`
}

func (pr *PostRepository) UpdatePost(userID, postID string, dto UpdatePostDTO) (apiError *utils.APIError) {
	database := pr.database

	var post models.Post

	err := database.Where("id = ? AND user_id = ?", postID, userID).First(&post).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "post not found",
			}
		}
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if dto.Type != "" {
		post.Type = models.PostType(dto.Type)
	}

	var postHasBeenFound bool

	if dto.HasBeenFound != nil && post.Type == models.Lost {
		post.HasBeenFound = *dto.HasBeenFound
		postHasBeenFound = *dto.HasBeenFound
	} else if dto.HasBeenFound != nil {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "post is found",
		}
	}

	var postHasBeenDelivered bool

	if dto.HasBeenDelivered != nil && post.Type == models.Found {
		post.HasBeenDelivered = *dto.HasBeenDelivered
		postHasBeenDelivered = *dto.HasBeenDelivered
	} else if dto.HasBeenDelivered != nil {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "post is lost",
		}
	}

	err = database.Save(&post).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if postHasBeenFound {
		pr.notificationRepository.AddObjectFoundNotification(post)
	}

	if postHasBeenDelivered {
		pr.notificationRepository.AddObjectDeliveredNotification(post)
	}

	return nil
}

func (pr *PostRepository) DeletePost(userID, postID string) (apiError *utils.APIError) {
	database := pr.database

	var post models.Post

	err := database.Where("id = ? AND user_id = ?", postID, userID).Preload("Images").First(&post).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "post not found",
			}
		}
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	err = database.Unscoped().Delete(&post).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}

type ClaimedOrFoundByUserID string

const (
	Claimed ClaimedOrFoundByUserID = "claimed"
	Found   ClaimedOrFoundByUserID = "found"
)

type GetPostsDTO struct {
	Content                string                 `form:"content"`
	Type                   string                 `form:"type" binding:"omitempty,oneof=lost found"`
	UserID                 string                 `form:"user_id"`
	ClaimedOrFoundByUserID ClaimedOrFoundByUserID `form:"claimed_or_found_by_user_id" binding:"omitempty,required_with=user_id,oneof=claimed found"`
	LocationLatitude       *float64               `form:"location_latitude" binding:"omitempty,required_with=LocationLongitude,min=-90,max=90"`
	LocationLongitude      *float64               `form:"location_longitude" binding:"omitempty,required_with=LocationLatitude,min=-180,max=180"`
	AppendWith             string                 `form:"append_with"`
	// HasBeenFound           *bool                  `form:"has_been_found" binding:"omitempty"`
	// HasBeenDelivered       *bool                  `form:"has_been_delivered" binding:"omitempty"`
	PageSize   int `form:"page_size,default=10" binding:"min=1"`
	PageNumber int `form:"page_number,default=1" binding:"min=1"`
}

type PagesData struct {
	Posts            []models.Post `json:"posts"`
	TotalPagesNumber uint          `json:"total_pages_number"`
	PageSize         int           `json:"page_size"`
	PageNumber       int           `json:"page_number"`
	PostsCount       int           `json:"posts_count"`
}

func (pr *PostRepository) GetPosts(filter GetPostsDTO) (posts *PagesData, apiError *utils.APIError) {
	database := pr.database

	fmt.Printf(
		"content: %s, type: %s, user_id: %s, claimed_or_found_by_user_id: %s, append_with: %s, page_size: %d, page_number: %d\n",
		filter.Content,
		filter.Type,
		filter.UserID,
		filter.ClaimedOrFoundByUserID,
		filter.AppendWith,
		// *filter.HasBeenFound,
		// *filter.HasBeenDelivered,
		filter.PageSize,
		filter.PageNumber,
	)

	query := database.Model(&models.Post{}).Select("posts.*, COUNT(DISTINCT claims.user_id) AS claimers_count, COUNT(DISTINCT founds.user_id) AS founders_count").
		Joins("LEFT JOIN claims ON posts.id = claims.post_id").
		Joins("LEFT JOIN founds ON posts.id = founds.post_id").
		Group("posts.id")

	if filter.Content != "" {
		contentQuery := "%" + strings.ToLower(filter.Content) + "%"
		query.Where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?", contentQuery, contentQuery)
	}

	if filter.Type != "" {
		query.Where("type = ?", filter.Type)
	}

	if filter.UserID != "" {
		query.Where("user_id = ?", filter.UserID)
		if filter.ClaimedOrFoundByUserID == Claimed {
			query.Where("claims.user_id = ?", filter.UserID)
		} else if filter.ClaimedOrFoundByUserID == Found {
			query.Where("founds.user_id = ?", filter.UserID)
		}
	}

	isLocationProvided := filter.LocationLatitude != nil && filter.LocationLongitude != nil && *filter.LocationLatitude != 0 && *filter.LocationLongitude != 0

	if isLocationProvided {
		query.Where("location_latitude BETWEEN ? AND ?", *filter.LocationLatitude-0.1, *filter.LocationLatitude+0.1)
		query.Where("location_longitude BETWEEN ? AND ?", *filter.LocationLongitude-0.1, *filter.LocationLongitude+0.1)
	}

	// if filter.HasBeenFound != nil {
	// 	query.Where("has_been_found = ?", *filter.HasBeenFound)
	// }

	// if filter.HasBeenDelivered != nil {
	// 	query.Where("has_been_delivered = ?", *filter.HasBeenDelivered)
	// }

	if filter.AppendWith != "" {
		extentions := utils.GetValidExtentions(
			filter.AppendWith,
			"claimers",
			"founders",
		)
		for _, extention := range extentions {
			query.Preload(extention)
		}
	}

	query.Preload("Images")
	query.Preload("User")


	query.Order("created_at DESC")

	var totalPosts int64
	err := query.Count(&totalPosts).Error
	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	totalPagesNumber := uint(totalPosts) / uint(filter.PageSize)
	latPagePostsCount := int(totalPosts) % filter.PageSize
	if latPagePostsCount > 0 {
		totalPagesNumber++
	}

	var existingPosts []models.Post
	err = query.Limit(filter.PageSize).Offset((filter.PageNumber - 1) * filter.PageSize).Find(&existingPosts).Error

	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return &PagesData{
		TotalPagesNumber: totalPagesNumber,
		Posts:            existingPosts,
		PageSize:         filter.PageSize,
		PageNumber:       filter.PageNumber,
		PostsCount:       int(totalPosts),
	}, nil
}

type GetPostDTO struct {
	AppendWith string `form:"append_with"`
}

func (pr *PostRepository) GetPost(postID string, filter GetPostDTO) (post *models.Post, apiError *utils.APIError) {
	database := pr.database

	query := database.
		Select("posts.*, COUNT(DISTINCT claims.user_id) AS claimers_count, COUNT(DISTINCT founds.user_id) AS founders_count").
		Joins("LEFT JOIN claims ON posts.id = claims.post_id").
		Joins("LEFT JOIN founds ON posts.id = founds.post_id").
		Group("posts.id").
		Where("posts.id = ?", postID)

	if filter.AppendWith != "" {
		extentions := utils.GetValidExtentions(
			filter.AppendWith,
			"user",
			"claimers",
			"founders",
		)
		for _, extention := range extentions {
			query.Preload(extention)
		}

	}

	var postToReturn models.Post

	err := query.First(&postToReturn).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "post not found",
			}
		}
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return &postToReturn, nil
}

func (pr *PostRepository) ClaimPost(userID, postID string) (apiError *utils.APIError) {
	database := pr.database

	var post models.Post

	err := database.Select("posts.*, COUNT(claims.post_id) > 0 as claimed_by_user").
		Joins("LEFT JOIN claims ON posts.id = claims.post_id AND claims.user_id = ?", userID).
		Group("posts.id").
		Where("posts.id = ?", postID).
		First(&post).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "post not found",
			}
		}
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if post.ClaimedByUser != nil && *post.ClaimedByUser {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you already claimed this post",
		}
	}

	if post.Type == models.Lost {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you can not claim a lost post",
		}
	}

	if post.UserID == userID {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you can't claim your own post",
		}
	}

	err = database.Create(&models.Claims{
		PostID: postID,
		UserID: userID,
	}).Error

	if err != nil {
		return &utils.APIError{
			Message:    err.Error(),
			StatusCode: http.StatusInternalServerError,
		}
	}

	pr.notificationRepository.AddClaimAddedNotification(post)

	return nil
}

func (pr *PostRepository) UnclaimPost(userID, postID string) (apiError *utils.APIError) {
	database := pr.database

	var post models.Post

	err := database.Select("posts.*, COUNT(claims.post_id) > 0 as claimed_by_user").
		Joins("LEFT JOIN claims ON posts.id = claims.post_id AND claims.user_id = ?", userID).
		Group("posts.id").
		Where("posts.id = ?", postID).
		First(&post).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "post not found",
			}
		}
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if post.ClaimedByUser != nil && !*post.ClaimedByUser {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you didn't claim this post",
		}
	}

	if post.UserID == userID {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you can't unclaim your own post",
		}
	}

	err = database.Model(&post).Association("Claimers").Unscoped().Delete(&models.User{ID: userID})
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}

func (pr *PostRepository) FoundPost(userID, postID string) (apiError *utils.APIError) {
	database := pr.database

	var post models.Post

	err := database.Select("posts.*, COUNT(founds.post_id) > 0 as found_by_user").
		Joins("LEFT JOIN founds ON posts.id = founds.post_id AND founds.user_id = ?", userID).
		Group("posts.id").
		Where("posts.id = ?", postID).
		First(&post).
		Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "post not found",
			}
		}
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if post.FoundByUser != nil && *post.FoundByUser {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you already found this post",
		}
	}

	if post.Type == models.Found {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you can not found a found post",
		}
	}

	if post.UserID == userID {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you can't found your own post",
		}
	}

	err = database.Create(&models.Founds{
		PostID: postID,
		UserID: userID,
	}).Error

	if err != nil {
		return &utils.APIError{
			Message:    err.Error(),
			StatusCode: http.StatusInternalServerError,
		}
	}

	pr.notificationRepository.AddFoundAddedNotification(post)

	return nil
}

func (pr *PostRepository) UnfoundPost(userID, postID string) (apiError *utils.APIError) {
	database := pr.database

	var post models.Post

	err := database.Select("posts.*, COUNT(founds.post_id) > 0 as found_by_user").
		Joins("LEFT JOIN founds ON posts.id = founds.post_id AND founds.user_id = ?", userID).
		Group("posts.id").
		Where("posts.id = ?", postID).
		First(&post).
		Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "post not found",
			}
		}
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if post.FoundByUser != nil && !*post.FoundByUser {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you didn't found this post",
		}
	}

	err = database.Model(&post).Association("Founders").Unscoped().Delete(&models.User{ID: userID})
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}
