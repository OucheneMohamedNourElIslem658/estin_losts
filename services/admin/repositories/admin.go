package repositories

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	filestorage "github.com/OucheneMohamedNourElIslem658/estin_losts/shared/file_storage"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"gorm.io/gorm"
)

type AdminRepository struct {
	database *gorm.DB
	filestorage *filestorage.FileStorage
}

func NewAdminRepository() *AdminRepository {
	return &AdminRepository{
		database: database.Instance,
		filestorage: filestorage.Instance,
	}
}

func (ar *AdminRepository) DeleteUser(userID string) (apiError *utils.APIError) {
	// find user and preload his posts
	var user models.User
	err := ar.database.Where("id = ?", userID).Preload("Posts.Images").First(&user).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "user not found",
			}
		}

		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error,
		}
	}

	if user.IsAdmin {
		return &utils.APIError{
			StatusCode: http.StatusForbidden,
			Message:    "you can't delete an admin",
		}
	}

	filestorage := ar.filestorage

	for _, post := range user.Posts {
		for _, image := range post.Images {
			err = filestorage.DeleteImage(image)
			if err != nil {
				return &utils.APIError{
					StatusCode: http.StatusInternalServerError,
					Message:    err.Error,
				}
			}
		}
	}

	err = ar.database.Unscoped().Delete(models.User{}, "id = ?", userID).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}