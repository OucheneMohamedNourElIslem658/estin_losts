package main

import (
	"fmt"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	filestorage "github.com/OucheneMohamedNourElIslem658/estin_losts/shared/file_storage"
)

func init() {
	database.Init()
	filestorage.Init()
}

func main() {
	fmt.Println("Hello, World!")
}
