package main

import (
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	filestorage "github.com/OucheneMohamedNourElIslem658/estin_losts/shared/file_storage"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/oauth"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
)

func init() {
	database.Init()
	filestorage.Init()
	oauth.Init()
	utils.InitValidators()
}

func main() {
	server := NewServer(":8000")
	server.Start()
}
