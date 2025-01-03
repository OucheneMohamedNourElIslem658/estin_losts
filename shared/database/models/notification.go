package models

type NotificationTag string

const (
	PostCreated     NotificationTag = "created"     // if post was created
	ObjectFound     NotificationTag = "found"       // if current user added found to a lost object and this last has been marked as found
	ObjectDelivered NotificationTag = "delivered"   // if claimed object has been delivered
	ClaimAdded      NotificationTag = "claim_added" // if lost object has been claimed
	FoundAdded      NotificationTag = "found_added" // if object has been claimed to be found by certain user
)

type Notification struct {
	ID     string          `gorm:"primaryKey" json:"id"`
	PostID string          `json:"course_id"`
	UserID string          `json:"user_id"`
	Post   *Post           `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"post,omitempty"`
	User   *User           `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE" json:"user,omitempty"`
	Seen   bool            `json:"seen"`
	Tag    NotificationTag `sql:"type:enum('created', 'found', 'delivered', 'claim_added', 'found_added')" gorm:"default:'created'" json:"tag"`
}