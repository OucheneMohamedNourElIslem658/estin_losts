package repositories

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"gorm.io/gorm"
)

type AdminRepository struct {
	database *gorm.DB
}

func NewAdminRepository() *AdminRepository {
	return &AdminRepository{
		database: database.Instance,
	}
}

func (ar *AdminRepository) DeleteUser(userID string) (apiError *utils.APIError) {
	var user models.User
	err := ar.database.Where("id = ?", userID).First(&user).Error
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

	err = ar.database.Unscoped().Delete(models.User{}, "id = ?", userID).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}