package models

import (
	"fmt"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type NotificationTag string

const (
	PostCreated     NotificationTag = "created"     // if post was created
	ObjectFound     NotificationTag = "found"       // if current user added found to a lost object and this last has been marked as found
	ObjectDelivered NotificationTag = "delivered"   // if claimed object has been delivered
	ClaimAdded      NotificationTag = "claim_added" // if lost object has been claimed
	FoundAdded      NotificationTag = "found_added" // if object has been claimed to be found by certain user
)

type Notification struct {
	ID        string          `gorm:"primaryKey,default:uuid_generate_v4()" json:"id"`
	PostID    string          `json:"course_id"`
	UserID    string          `json:"user_id"`
	Post      *Post           `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"post,omitempty"`
	User      *User           `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"user,omitempty"`
	Seen      bool            `gorm:"default:false" json:"seen"`
	Tag       NotificationTag `sql:"type:enum('created', 'found', 'delivered', 'claim_added', 'found_added')" gorm:"default:'created'" json:"tag"`
	CreatedAt time.Time       `json:"created_at"`
}

func (n *Notification) BeforeCreate(tx *gorm.DB) (err error) {
	n.ID = uuid.New().String()
	fmt.Println(n.ID)
	return
}
