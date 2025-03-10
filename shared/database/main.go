package database

import (
	"log"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var Instance *gorm.DB

func Init() {
	dsn := Envs.GetDatabaseDSN()

	var err error
	Instance, err = gorm.Open(postgres.New(
		postgres.Config{
			DSN:                  dsn,
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

	err = CreateUUIDExtension(Instance)
	if err != nil {
		log.Fatal(err)
	}

	log.Println("Database connected succesfully!")
}

func migrateTables() error {
	err := Instance.AutoMigrate(
		&models.User{},
		&models.Post{},
		&models.Image{},
		&models.Claims{},
		&models.Founds{},
		&models.Notification{},
	)
	if err != nil {
		return err
	}
	return nil
}

func CreateUUIDExtension(db *gorm.DB) error {
	err := db.Exec(`CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`).Error
	if err != nil {
		log.Fatalf("Error creating UUID extension: %v", err)
		return err
	}
	log.Println("UUID extension created successfully!")
	return nil
}
