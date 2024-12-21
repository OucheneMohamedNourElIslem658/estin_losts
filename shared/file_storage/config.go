package filestorage

import (
	"os"

	"github.com/joho/godotenv"
)

type config struct {
	secretKey  string
	accessKey  string
	url        string
	bucketName string
}

var envs = initAPI()

func initAPI() config {
	godotenv.Load()
	return config{
		accessKey:  os.Getenv("MINIO_ACCESS_KEY"),
		secretKey:  os.Getenv("MINIO_SECRET_KEY"),
		url:        os.Getenv("MINIO_ENDPOINT_URL"),
		bucketName: os.Getenv("MINIO_BUCKET_NAME"),
	}
}
