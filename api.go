package main

import (
	notificationsRouter "github.com/OucheneMohamedNourElIslem658/estin_losts/services/notifications/routers"
	postsRouters "github.com/OucheneMohamedNourElIslem658/estin_losts/services/posts/routers"
	usersRouters "github.com/OucheneMohamedNourElIslem658/estin_losts/services/users/routers"
	"github.com/gin-gonic/gin"
)

type Server struct {
	address string
}

func NewServer(address string) *Server {
	return &Server{
		address: address,
	}
}

func (s *Server) Start() {
	router := gin.Default()

	router.GET("/", func(c *gin.Context) {
		c.String(200, "Hello, World!")
	})

	v1 := router.Group("/api/v1")
	
	usersRouter := v1.Group("/users")

	subRoute := usersRouter.Group("/auth")
	authRouter := usersRouters.NewAuthRouter(subRoute)
	authRouter.RegisterRoutes()

	subRoute = usersRouter.Group("/profiles")
	profilesRouter := usersRouters.NewProfilesRouter(subRoute)
	profilesRouter.RegisterRoutes()

	subRoute = v1.Group("/posts")
	postsRouter := postsRouters.NewPostsRouter(subRoute)
	postsRouter.RegisterRoutes()

	subRoute = v1.Group("/notifications")
	notificationsRouter := notificationsRouter.NewNotificationsRouter(subRoute)
	notificationsRouter.RegisterRoutes()


	router.Run(s.address)
}
