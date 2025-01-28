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
	ID                string     `gorm:"primaryKey" json:"id"`
	CreatedAt         time.Time  `json:"created_at"`
	TimeAgo           *string    `gorm:"-:migration;->" json:"time_ago,omitempty"`
	UpdatedAt         time.Time  `json:"updated_at"`
	Title             string     `json:"title"`
	Description       *string    `json:"description"`
	Time              *time.Time `gorm:"default:CURRENT_TIMESTAMP" json:"time,omitempty"`
	LocationLatitude  *float64   `json:"location_latitude"`
	LocationLongitude *float64   `json:"location_longitude"`
	Type              PostType   `sql:"type:ENUM('lost', 'found')" gorm:"default:'lost'" json:"type"`
	HasBeenFound      bool       `gorm:"default:false" json:"has_been_found"`
	HasBeenDelivered  bool       `gorm:"default:false" json:"has_been_delivered"`
	ClaimedByUser     *bool      `gorm:"-:migration;->" json:"claimed_by_user,omitempty"`
	FoundByUser       *bool      `gorm:"-:migration;->" json:"found_by_user,omitempty"`
	UserID            string     `json:"user_id"`
	User              *User      `json:"user,omitempty"`
	Images            []Image    `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"images"`
	ClaimersCount     *uint      `gorm:"-:migration;->" json:"claimers_count,omitempty"`
	Claimers          []User     `gorm:"many2many:claims" json:"claimers,omitempty"`
	FoundersCount     *uint      `gorm:"-:migration;->" json:"founders_count,omitempty"`
	Founders          []User     `gorm:"many2many:founds" json:"founders,omitempty"`
}

func (p *Post) BeforeCreate(tx *gorm.DB) (err error) {
	p.ID = uuid.New().String()
	return
}

type Image struct {
	ID                string `gorm:"primaryKey" json:"id"`
	Name              string `gorm:"not null" json:"name"`
	URL               string `gorm:"unique,not null" json:"url"`
	FileStorageFolder string `json:"file_storage_folder"`
	PostID            string `json:"post_id"`
	Post              *Post  `json:"post,omitempty"`
}

func (i *Image) BeforeCreate(tx *gorm.DB) (err error) {
	i.ID = uuid.New().String()
	return
}
