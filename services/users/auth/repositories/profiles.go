package repositories

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	gorm "gorm.io/gorm"
)

type ProfilesRepository struct {
	database *gorm.DB
}

func NewProfilesRepository() *ProfilesRepository {
	return &ProfilesRepository{
		database: database.Instance,
	}
}

func (UsersRouter *ProfilesRepository) GetUser(id string) (user *models.User, apiError *utils.APIError) {
	database := UsersRouter.database

	var existingUser models.User
	err := database.Where("id = ?", id).First(&existingUser).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "user not found",
			}
		}
		return nil, &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return &existingUser, nil
}

type UserUpdateDTO struct {
	FullName string `json:"full_name"`
}

func (UsersRouter *ProfilesRepository) UpdateUser(id string, newUser UserUpdateDTO) (apiError *utils.APIError) {
	database := UsersRouter.database

	var existingUser models.User
	err := database.Where("id = ?", id).First(&existingUser).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return &utils.APIError{
				StatusCode: http.StatusNotFound,
				Message:    "user not found",
			}
		}

		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	if newUser.FullName != "" {
		existingUser.FullName = newUser.FullName
	}

	err = database.Save(&existingUser).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}
