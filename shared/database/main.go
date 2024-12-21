package database

import (
	"log"

	// "github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var Instance *gorm.DB

func Init() {
	dsn := envs.getDatabaseDSN()

	var err error
	Instance, err = gorm.Open(postgres.New(
		postgres.Config{
			DSN: dsn,
			PreferSimpleProtocol: true,
		},
	), &gorm.Config{})
	if err != nil {
		log.Fatal(err.Error())
	}

	err = migrateTables()
	if err != nil {
		log.Fatal(err)
	}

	log.Println("Database connected succesfully!")
}

func migrateTables() error {
	err := Instance.AutoMigrate(
		// &models.User{},
		// &models.Post{},
		// &models.Image{},
		// &models.Claims{},
		// &models.Founds{},
		// &models.Notification{},
	)
	if err != nil {
		return err
	}
	return nil
}