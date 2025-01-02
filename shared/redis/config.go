package redis

import (
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	Host     string
	Port     string
	Password string
}

var envs Config

func NewConfig()  {
	if err := godotenv.Load(); err != nil {
		panic(err)
	}

	envs = Config{
		Host:     os.Getenv("REDIS_HOST"),
		Port:     os.Getenv("REDIS_PORT"),
		Password: os.Getenv("REDIS_PASSWORD"),
	}
}
