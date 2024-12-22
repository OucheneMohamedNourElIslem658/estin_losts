package routers

import (
	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/posts/controllers"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/middlewares"
	"github.com/gin-gonic/gin"
)

type PostsRouter struct {
	Router          *gin.RouterGroup
	postsController *controllers.PostsController
	authMiddlewares *middlewares.AuthorizationMiddlewares
}

func NewPostsRouter(router *gin.RouterGroup) *PostsRouter {
	return &PostsRouter{
		Router:          router,
		postsController: controllers.NewPostsController(),
		authMiddlewares: middlewares.NewAuthorizationMiddlewares(),
	}
}

func (pr *PostsRouter) RegisterRoutes() {
	router := pr.Router
	postsController := pr.postsController

	authMiddlewares := pr.authMiddlewares
	authorization := authMiddlewares.Authorization()
	authorizationWithUserCheck := authMiddlewares.AuthorizationWithUserCheck()

	router.POST("/", authorization, authorizationWithUserCheck, postsController.CreatePost)
	router.GET("/", postsController.GetPosts)
	router.GET("/:post_id", postsController.GetPost)
	router.PUT("/:post_id", authorization, authorizationWithUserCheck, postsController.UpdatePost)
	router.DELETE("/:post_id", authorization, authorizationWithUserCheck, postsController.DeletePost)
	router.POST("/:post_id/claim", authorization, authorizationWithUserCheck, postsController.ClaimPost)
	router.DELETE("/:post_id/unclaim", authorization, authorizationWithUserCheck, postsController.UnclaimPost)
	router.POST("/:post_id/found", authorization, authorizationWithUserCheck, postsController.FoundPost)
	router.DELETE("/:post_id/unfound", authorization, authorizationWithUserCheck, postsController.UnfoundPost)
}
