package repositories

import (
	"mime/multipart"
	"net/http"
	"strings"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	filestorage "github.com/OucheneMohamedNourElIslem658/estin_losts/shared/file_storage"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"gorm.io/gorm"
)

type PostRepository struct {
	database    *gorm.DB
	filestorage *filestorage.FileStorage
}

func NewPostRepository() *PostRepository {
	return &PostRepository{
		database:    database.Instance,
		filestorage: filestorage.Instance,
	}
}

type CreatePostDTO struct {
	Title             string                  `form:"title" binding:"required"`
	Description       string                  `form:"description"`
	LocationLatitude  *float64                `form:"location_latitude" binding:"omitempty,min=-90,max=90,required_with=LocationLongitude"`
	LocationLongitude *float64                `form:"location_longitude" binding:"omitempty,min=-180,max=180,required_with=LocationLatitude"`
	Type              string                  `form:"type" binding:"required,oneof=lost found"`
	Images            []*multipart.FileHeader `form:"images" binding:"omitempty,max=3,dive,image"`
}

func (pr *PostRepository) CreatePost(userID string, dto CreatePostDTO) (post *models.Post, apiError *utils.APIError) {
	database := pr.database

	filestorage := filestorage.Instance

	images, err := filestorage.UploadFiles(dto.Images, "posts", nil)
	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	postToCreate := models.Post{
		Title:             dto.Title,
		Description:       &dto.Description,
		LocationLatitude:  dto.LocationLatitude,
		LocationLongitude: dto.LocationLongitude,
		Type:              models.PostType(dto.Type),
		UserID:            userID,
		Images:            images,
	}

	err = database.Create(&postToCreate).Error
	if err != nil {
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return &postToCreate, nil
}

type UpdatePostDTO struct {
	Type             string `form:"type" binding:"omitempty,oneof=lost found,default=lost"`
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

	if dto.HasBeenFound != nil && post.Type == models.Lost {
		post.HasBeenFound = *dto.HasBeenFound
	}

	if dto.HasBeenDelivered != nil && post.Type == models.Found {
		post.HasBeenDelivered = *dto.HasBeenDelivered
	}

	err = database.Save(&post).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
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

	filestorage := pr.filestorage

	for _, image := range post.Images {
		err = filestorage.DeleteImage(image)
		if err != nil {
			return &utils.APIError{
				StatusCode: http.StatusInternalServerError,
				Message:    err.Error(),
			}
		}
	}

	err = database.Delete(&post).Error
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
	Content                         string                 `form:"content"`
	Type                            string                 `form:"type"`
	UserID                          string                 `form:"user_id"`
	ClaimedOrFoundByUserID          ClaimedOrFoundByUserID `form:"claimed_or_found_by_user_id" binding:"omitempty,required_with=user_id,onof=claimed found"`
	LocalctionLatitudeApproximation *float64               `form:"location_latitude_approximation" binding:"omitempty,min=-90,max=90,required_with=LocationLongitudeApproximation"`
	LocationLongitudeApproximation  *float64               `form:"location_longitude_approximation" binding:"omitempty,min=-180,max=180,required_with=LocationLatitudeApproximation"`
	AppendWith                      string                 `form:"append_with"`
	HasBeenFound                    *bool                  `form:"has_been_found"`
	HasBeenDelivered                *bool                  `form:"has_been_delivered"`
	PageSize                        int                    `form:"page_size" binding:"min=1, default=10"`
	PageNumber                      int                    `form:"page_number" binding:"min=1, default=1"`
}

func (pr *PostRepository) GetPosts(filter GetPostsDTO) (posts []models.Post, TotalPagesNumber *uint, apiError *utils.APIError) {
	database := pr.database

	query := database.Select("posts.*, COUNT(DISTINCT claims.user_id) AS claimers_count, COUNT(DISTINCT founds.user_id) AS founders_count").
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

	if filter.LocalctionLatitudeApproximation != nil && filter.LocationLongitudeApproximation != nil {
		query.Where("location_latitude BETWEEN ? AND ?", *filter.LocalctionLatitudeApproximation-0.1, *filter.LocalctionLatitudeApproximation+0.1)
		query.Where("location_longitude BETWEEN ? AND ?", *filter.LocationLongitudeApproximation-0.1, *filter.LocationLongitudeApproximation+0.1)
	}

	if filter.AppendWith != "" {
		extentions := utils.GetValidExtentions(
			filter.AppendWith,
			"user",
			"calimers",
			"fonders",
		)
		for _, extention := range extentions {
			query.Preload(extention)
		}
	}

	query.Order("created_at DESC")

	var totalPosts int64
	err := query.Count(&totalPosts).Error
	if err != nil {
		return nil, nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	totalPagesNumber := uint(totalPosts) / uint(filter.PageSize)

	err = query.Limit(filter.PageSize).Offset((filter.PageNumber - 1) * filter.PageSize).Find(&posts).Error

	if err != nil {
		return nil, nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return posts, &totalPagesNumber, nil
}

type GetPostDTO struct {
	AppendWith string `form:"append_with"`
}

func (pr *PostRepository) GetPost(postID string, filter GetPostDTO) (post *models.Post, apiError *utils.APIError) {
	database := pr.database

	query := database

	query.Select("posts.*, COUNT(DISTINCT claims.user_id) AS claimers_count, COUNT(DISTINCT founds.user_id) AS founders_count").
		Joins("LEFT JOIN claims ON posts.id = claims.post_id").
		Joins("LEFT JOIN founds ON posts.id = founds.post_id").
		Group("posts.id")

	if filter.AppendWith != "" {
		extentions := utils.GetValidExtentions(
			filter.AppendWith,
			"user",
			"calimers",
			"fonders",
		)
		for _, extention := range extentions {
			query.Preload(extention)
		}

	}

	var postToReturn models.Post

	err := query.Where("id = ?", postID).First(&postToReturn).Error
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

	err := database.Where("id = ?", postID).First(&post).Error
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

	if post.Type == models.Found {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "post is found",
		}
	}

	if post.UserID == userID {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you can't claim your own post",
		}
	}

	err = database.Model(&post).Association("Claimers").Append(&models.User{ID: userID})
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}

func (pr *PostRepository) UnclaimPost(userID, postID string) (apiError *utils.APIError) {
	database := pr.database

	var post models.Post

	err := database.Where("id = ?", postID).First(&post).Error
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

	err := database.Where("id = ?", postID).First(&post).Error
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

	if post.Type == models.Lost {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "post is lost",
		}
	}

	if post.UserID == userID {
		return &utils.APIError{
			StatusCode: http.StatusConflict,
			Message:    "you can't found your own post",
		}
	}

	err = database.Model(&post).Association("Founders").Append(&models.User{ID: userID})
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}

func (pr *PostRepository) UnfoundPost(userID, postID string) (apiError *utils.APIError) {
	database := pr.database

	var post models.Post

	err := database.Where("id = ?", postID).First(&post).Error
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

	err = database.Model(&post).Association("Founders").Unscoped().Delete(&models.User{ID: userID})
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}
