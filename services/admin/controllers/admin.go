package controllers

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/admin/repositories"
	"github.com/gin-gonic/gin"
)

type AdminController struct {
	adminRepository repositories.AdminRepository
}

func NewAdminController() *AdminController {
	return &AdminController{
		adminRepository: *repositories.NewAdminRepository(),
	}
}

func (ac *AdminController) DeleteUser(ctx *gin.Context) {
	userID := ctx.Param("user_id")

	err := ac.adminRepository.DeleteUser(userID)
	if err != nil {
		ctx.JSON(err.StatusCode, gin.H{
			"error": err.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}