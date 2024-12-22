package controllers

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/users/repositories"
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