package main

import (
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/realtime"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/file_storage"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/oauth"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/utils"
)

func init() {
	database.Init()
	realtime.Init()
	filestorage.Init()
	oauth.Init()
	utils.InitValidators()
}

func main() {
	server := NewServer("192.168.217.136:8000")
	server.Start()
}