package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type User struct {
	ID            string `gorm:"primaryKey" json:"id"`
	Email         string `gorm:"unique;not null" json:"email"`
	FullName      string `gorm:"not null" json:"full_name"`
	ImageURL      string `gorm:"unique;not null" json:"image_url"`
	Disabled      bool   `json:"disabled"`
	IsAdmin       bool   `json:"is_admin"`
	Posts         []Post `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"posts,omitempty"`
	Claims        []Post `gorm:"many2many:claims" json:"claims,omitempty"`
	Founds        []Post `gorm:"many2many:founds" json:"founds,omitempty"`
	Notifications []Post `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"notifications,omitempty"`
}

func (u *User) BeforeCreate(tx *gorm.DB) (err error) {
	u.ID = uuid.New().String()
	return
}

type Claims struct {
	PostID string `gorm:"primaryKey" json:"course_id"`
	UserID string `gorm:"primaryKey" json:"user_id"`
	Post   *Post  `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"post,omitempty"`
	User   *User  `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"user,omitempty"`
}

type Founds struct {
	PostID string `gorm:"primaryKey" json:"course_id"`
	UserID string `gorm:"primaryKey" json:"user_id"`
	Post   *Post  `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"post,omitempty"`
	User   *User  `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"user,omitempty"`
}
