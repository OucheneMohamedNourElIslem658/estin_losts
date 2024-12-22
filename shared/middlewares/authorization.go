package middlewares

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/users/repositories"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"github.com/gin-gonic/gin"
)

type AuthorizationMiddlewares struct {
	authRepository *repositories.AuthRepository
}

func NewAuthorizationMiddlewares() *AuthorizationMiddlewares {
	return &AuthorizationMiddlewares{
		authRepository: repositories.NewAuthRepository(),
	}
}

func (am *AuthorizationMiddlewares) Authorization() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		authorization := ctx.GetHeader("Authorization")

		if authorization != "" {
			idToken := authorization[len("Bearer "):]

			if idToken != "" {
				claims, _, err := utils.VerifyIDToken(idToken)

				if err != nil {
					refreshToken := ctx.GetHeader("refresh_token")

					idToken, apiError := am.authRepository.RefreshIdToken(refreshToken)
					if apiError != nil {
						ctx.AbortWithStatusJSON(apiError.StatusCode, gin.H{
							"error": apiError.Message,
						})
						return
					}

					ctx.SetCookie("id_token", *idToken, 3600, "/", "", false, true)
					claims, _, _ = utils.VerifyIDToken(*idToken)
				}

				ctx.Set("id", claims.ID)
				ctx.Set("is_admin", claims.IsAdmin)
			}
		}
		ctx.Next()
	}
}

func (am *AuthorizationMiddlewares) AuthorizationWithUserCheck() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		id := ctx.GetString("id")

		if id == "" {
			ctx.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error": "requester is not a user",
			})
			return
		}

		ctx.Next()
	}
}

func (am *AuthorizationMiddlewares) AuthorizationWithAdminCheck() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		isAdmin := ctx.GetBool("is_admin")

		if !isAdmin {
			ctx.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error": "requester is not an admin",
			})
			return
		}

		ctx.Next()
	}
}
