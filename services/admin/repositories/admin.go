package repositories

import (
	"net/http"
	"strings"

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

func (ar *AdminRepository) EnableDisableUser(userID string, disabled bool) (apiError *utils.APIError) {
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
			Message:    "you can't disble or enable an admin",
		}
	}

	err = ar.database.Model(&user).Update("disabled", disabled).Error
	if err != nil {
		return &utils.APIError{
			StatusCode: http.StatusInternalServerError,
			Message:    err.Error(),
		}
	}

	return nil
}

type UsersQuery struct {
	Email    string `form:"email"`
	Page     int    `form:"page,default=10" binding:"omitempty,min=1"`
	PageSize int    `form:"page_size,default=1" binding:"omitempty,min=1"`
}

type PagesData struct {
	Page             int           `json:"page"`
	PageSize         int           `json:"page_size"`
	TotalPagesNumber int           `json:"total_pages_number"`
	Users            []models.User `json:"users"`
}

func (ar *AdminRepository) GetUsers(usersQuery UsersQuery) (pagesData PagesData, apiError *utils.APIError) {
	var users []models.User
	query := ar.database.Model(&models.User{})

	if usersQuery.Email != "" {
		query = query.Where("LOWER(email) LIKE ?", "%"+strings.ToLower(usersQuery.Email)+"%")
	}

	var totalUsersNumber int64
	query.Count(&totalUsersNumber)

	pagesData.Page = usersQuery.Page
	pagesData.PageSize = usersQuery.PageSize
	pagesData.TotalPagesNumber = int(totalUsersNumber) / usersQuery.PageSize

	if int(totalUsersNumber)%usersQuery.PageSize != 0 {
		pagesData.TotalPagesNumber++
	}

	query.Limit(usersQuery.PageSize).Offset((usersQuery.Page - 1) * usersQuery.PageSize).Find(&users)
	pagesData.Users = users

	return pagesData, nil
}