package main

import (
	"log"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	filestorage "github.com/OucheneMohamedNourElIslem658/estin_losts/shared/file_storage"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/oauth"
)

func init() {
	database.Init()
	filestorage.Init()
	oauth.Init()
}

func main() {
	server := NewServer(":8000")
	log.Println("Server is running on port 8080")
	server.Start()
}
