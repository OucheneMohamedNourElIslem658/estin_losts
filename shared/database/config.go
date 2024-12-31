package database

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	User     string
	Password string
	Host     string
	Port     string
	Name     string
}

var Envs = initAPI()

func initAPI() Config {
	if err := godotenv.Load(); err != nil {
		log.Fatalf("Error loading .env file")
	}
	return Config{
		User:     os.Getenv("DB_USER"),
		Password: os.Getenv("DB_PASSWORD"),
		Host:     os.Getenv("DB_HOST"),
		Port:     os.Getenv("DB_PORT"),
		Name:     os.Getenv("DB_NAME"),
	}
}

func (Config Config) GetDatabaseDSN() string {
	return fmt.Sprintf(
		"host=%v user=%v password=%v dbname=%v port=%v sslmode=disable",
		Config.Host,
		Config.User,
		Config.Password,
		Config.Name,
		Config.Port,
	)
}
