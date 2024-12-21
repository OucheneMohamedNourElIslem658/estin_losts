package main

import (
	"github.com/OucheneMohamedNourElIslem658/estin_losts/services/users/auth/routers"
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
	authRouter := routers.NewAuthRouter(subRoute)
	authRouter.RegisterRoutes()

	subRoute = usersRouter.Group("/profiles")
	profilesRouter := routers.NewProfilesRouter(subRoute)
	profilesRouter.RegisterRoutes()

	router.Run(s.address)
}