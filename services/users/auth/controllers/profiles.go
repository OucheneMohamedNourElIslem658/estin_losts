package controllers

import (
	"fmt"
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/users/auth/repositories"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"github.com/gin-gonic/gin"
)

type ProfilesController struct {
	profilesRepository *repositories.ProfilesRepository
}

func NewProfilesController() *ProfilesController {
	return &ProfilesController{
		profilesRepository: repositories.NewProfilesRepository(),
	}
}

func (pc *ProfilesController) GetProfile(ctx *gin.Context) {
	userID := ctx.GetString("id")

	profilesRepository := pc.profilesRepository
	user, err := profilesRepository.GetUser(userID)
	if err != nil {
		ctx.JSON(err.StatusCode, gin.H{
			"error": err.Message,
		})
		return
	}

	ctx.JSON(http.StatusOK, user)
}

func (pc *ProfilesController) UpdateProfile(ctx *gin.Context) {
	id := ctx.GetString("id")

	var newUser repositories.UserUpdateDTO

	if err := ctx.ShouldBindJSON(&newUser); err != nil {
		message := utils.ValidationErrorResponse(err, newUser)
		ctx.JSON(http.StatusBadRequest, message)
		fmt.Println(err.Error())
		return
	}

	profilesRepository := pc.profilesRepository
	err := profilesRepository.UpdateUser(id, newUser)
	if err != nil {
		ctx.JSON(err.StatusCode, gin.H{
			"error": err.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}