package oauth

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type config struct {
	googleClientID     string
	googleClientSecret string
	redirectURL        string
}

var envs = initAPI()

func initAPI() config {
	if err := godotenv.Load(); err != nil {
		log.Fatalf("Error loading .env file")
	}

	return config{
		googleClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		googleClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		redirectURL:        os.Getenv("HOST") + "/api/v1/users/auth/oauth/google/callback",
	}
}
