package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type PostType string

const (
	Lost  PostType = "lost"
	Found PostType = "found"
)

type Post struct {
	ID                string    `gorm:"primaryKey" json:"id"`
	CreatedAt         time.Time `json:"created_at"`
	UpdatedAt         time.Time `json:"updated_at"`
	Title             string    `json:"title"`
	Description       *string   `json:"description"`
	LocationLatitude  *float64  `json:"location_latitude"`
	LocationLongitude *float64  `json:"location_longitude"`
	Type              PostType  `sql:"type:ENUM('lost', 'found')" gorm:"default:'lost'" json:"type"`
	HasBeenFound      bool      `json:"has_been_found"`
	HasBeenDelivered  bool      `json:"has_been_delivered"`
	UserID            string    `json:"user_id"`
	User              *User     `json:"user,omitempty"`
	Images            []Image   `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"images,omitempty"`
	Claimers          []User    `gorm:"many2many:claims" json:"claimers,omitempty"`
	Founders          []User    `gorm:"many2many:founds" json:"founders,omitempty"`
}

func (p *Post) BeforeCreate(tx *gorm.DB) (err error) {
	p.ID = uuid.New().String()
	return
}

type Image struct {
	ID            string `gorm:"primaryKey" json:"id"`
	Name          string `gorm:"not null" json:"name"`
	URL           string `gorm:"unique,not null" json:"url"`
	FileStorageID string `gorm:"unique,not null" json:"file_storage_id"`
	PostID        string `json:"post_id"`
	Post          *Post  `json:"post,omitempty"`
}

func (i *Image) BeforeCreate(tx *gorm.DB) (err error) {
	i.ID = uuid.New().String()
	return
}
