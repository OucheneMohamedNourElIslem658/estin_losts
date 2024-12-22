package controllers

import (
	"net/http"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/posts/repositories"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
	"github.com/gin-gonic/gin"
)

type PostsController struct {
	postsRepository *repositories.PostRepository
}

func NewPostsController() *PostsController {
	return &PostsController{
		postsRepository: repositories.NewPostRepository(),
	}
}

func (pc *PostsController) CreatePost(ctx *gin.Context) {
	var dto repositories.CreatePostDTO
	if err := ctx.ShouldBind(&dto); err != nil {
		message := utils.ValidationErrorResponse(err, dto)
		ctx.JSON(http.StatusBadRequest, message)
		return
	}

	id := ctx.GetString("id")

	post, apiError := pc.postsRepository.CreatePost(id, dto)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.JSON(http.StatusCreated, post)
}

func (pc *PostsController) GetPosts(ctx *gin.Context) {
	var dto repositories.GetPostsDTO
	if err := ctx.ShouldBind(&dto); err != nil {
		message := utils.ValidationErrorResponse(err, dto)
		ctx.JSON(http.StatusBadRequest, message)
		return
	}

	posts, totalPagesNumber, apiError := pc.postsRepository.GetPosts(dto)

	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"total_pages_number": totalPagesNumber,
		"posts":              posts,
	})
}

func (pc *PostsController) GetPost(ctx *gin.Context) {
	var dto repositories.GetPostDTO
	if err := ctx.ShouldBind(&dto); err != nil {
		message := utils.ValidationErrorResponse(err, dto)
		ctx.JSON(http.StatusBadRequest, message)
		return
	}

	postID := ctx.Param("post_id")

	post, apiError := pc.postsRepository.GetPost(postID, dto)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.JSON(http.StatusOK, post)
}

func (pc *PostsController) UpdatePost(ctx *gin.Context) {
	var dto repositories.UpdatePostDTO
	if err := ctx.ShouldBind(&dto); err != nil {
		message := utils.ValidationErrorResponse(err, dto)
		ctx.JSON(http.StatusBadRequest, message)
		return
	}

	postID := ctx.Param("post_id")
	id := ctx.GetString("id")

	apiError := pc.postsRepository.UpdatePost(id, postID, dto)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}

func (pc *PostsController) DeletePost(ctx *gin.Context) {
	postID := ctx.Param("post_id")
	id := ctx.GetString("id")

	apiError := pc.postsRepository.DeletePost(id, postID)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}

func (pc *PostsController) ClaimPost(ctx *gin.Context) {
	postID := ctx.Param("post_id")
	id := ctx.GetString("id")

	apiError := pc.postsRepository.ClaimPost(id, postID)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}

func (pc *PostsController) UnclaimPost(ctx *gin.Context) {
	postID := ctx.Param("post_id")
	id := ctx.GetString("id")

	apiError := pc.postsRepository.UnclaimPost(id, postID)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}

func (pc *PostsController) FoundPost(ctx *gin.Context) {
	postID := ctx.Param("post_id")
	id := ctx.GetString("id")

	apiError := pc.postsRepository.FoundPost(id, postID)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}

func (pc *PostsController) UnfoundPost(ctx *gin.Context) {
	postID := ctx.Param("post_id")
	id := ctx.GetString("id")

	apiError := pc.postsRepository.UnfoundPost(id, postID)
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, gin.H{
			"error": apiError.Message,
		})
		return
	}

	ctx.Status(http.StatusOK)
}