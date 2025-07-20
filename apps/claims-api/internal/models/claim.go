package models

import (
	"time"

	"gorm.io/gorm"
)

// ClaimStatus represents the status of an insurance claim
type ClaimStatus string

const (
	ClaimStatusPending   ClaimStatus = "pending"
	ClaimStatusReviewing ClaimStatus = "reviewing"
	ClaimStatusApproved  ClaimStatus = "approved"
	ClaimStatusRejected  ClaimStatus = "rejected"
	ClaimStatusClosed    ClaimStatus = "closed"
)

// ClaimType represents the type of insurance claim
type ClaimType string

const (
	ClaimTypeAuto     ClaimType = "auto"
	ClaimTypeHealth   ClaimType = "health"
	ClaimTypeHome     ClaimType = "home"
	ClaimTypeLife     ClaimType = "life"
	ClaimTypeTravel   ClaimType = "travel"
	ClaimTypeBusiness ClaimType = "business"
)

// Claim represents an insurance claim in the system
type Claim struct {
	ID               uint        `json:"id" gorm:"primaryKey"`
	ClaimNumber      string      `json:"claim_number" gorm:"uniqueIndex;not null"`
	PolicyNumber     string      `json:"policy_number" gorm:"not null"`
	CustomerID       uint        `json:"customer_id" gorm:"not null"`
	ClaimType        ClaimType   `json:"claim_type" gorm:"not null"`
	Status           ClaimStatus `json:"status" gorm:"default:pending"`
	Description      string      `json:"description" gorm:"type:text"`
	IncidentDate     time.Time   `json:"incident_date" gorm:"not null"`
	ReportedDate     time.Time   `json:"reported_date" gorm:"default:CURRENT_TIMESTAMP"`
	ClaimedAmount    float64     `json:"claimed_amount" gorm:"type:decimal(12,2)"`
	ApprovedAmount   *float64    `json:"approved_amount,omitempty" gorm:"type:decimal(12,2)"`
	IncidentLocation string      `json:"incident_location"`
	ContactPhone     string      `json:"contact_phone"`
	ContactEmail     string      `json:"contact_email"`
	AssignedAdjuster *string     `json:"assigned_adjuster,omitempty"`

	// Audit fields
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`

	// Relations
	Customer     *Customer      `json:"customer,omitempty" gorm:"foreignKey:CustomerID"`
	Documents    []Document     `json:"documents,omitempty" gorm:"foreignKey:ClaimID"`
	ClaimHistory []ClaimHistory `json:"claim_history,omitempty" gorm:"foreignKey:ClaimID"`
}

// Customer represents a customer in the system
type Customer struct {
	ID          uint       `json:"id" gorm:"primaryKey"`
	FirstName   string     `json:"first_name" gorm:"not null"`
	LastName    string     `json:"last_name" gorm:"not null"`
	Email       string     `json:"email" gorm:"uniqueIndex;not null"`
	Phone       string     `json:"phone"`
	DateOfBirth *time.Time `json:"date_of_birth,omitempty"`
	Address     string     `json:"address"`
	City        string     `json:"city"`
	State       string     `json:"state"`
	ZipCode     string     `json:"zip_code"`

	// Audit fields
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`

	// Relations
	Claims []Claim `json:"claims,omitempty" gorm:"foreignKey:CustomerID"`
}

// Document represents a document attached to a claim
type Document struct {
	ID          uint   `json:"id" gorm:"primaryKey"`
	ClaimID     uint   `json:"claim_id" gorm:"not null"`
	FileName    string `json:"file_name" gorm:"not null"`
	FileSize    int64  `json:"file_size"`
	FileType    string `json:"file_type"`
	S3Bucket    string `json:"s3_bucket"`
	S3Key       string `json:"s3_key"`
	UploadedBy  string `json:"uploaded_by"`
	Description string `json:"description"`

	// Audit fields
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`

	// Relations
	Claim *Claim `json:"claim,omitempty" gorm:"foreignKey:ClaimID"`
}

// ClaimHistory represents the history of changes made to a claim
type ClaimHistory struct {
	ID        uint    `json:"id" gorm:"primaryKey"`
	ClaimID   uint    `json:"claim_id" gorm:"not null"`
	Action    string  `json:"action" gorm:"not null"`
	OldValue  *string `json:"old_value,omitempty"`
	NewValue  *string `json:"new_value,omitempty"`
	ChangedBy string  `json:"changed_by" gorm:"not null"`
	Comments  string  `json:"comments"`

	// Audit fields
	CreatedAt time.Time `json:"created_at"`

	// Relations
	Claim *Claim `json:"claim,omitempty" gorm:"foreignKey:ClaimID"`
}

// CreateClaimRequest represents the request payload for creating a new claim
type CreateClaimRequest struct {
	PolicyNumber     string    `json:"policy_number" validate:"required"`
	CustomerID       uint      `json:"customer_id" validate:"required"`
	ClaimType        ClaimType `json:"claim_type" validate:"required,oneof=auto health home life travel business"`
	Description      string    `json:"description" validate:"required,min=10"`
	IncidentDate     time.Time `json:"incident_date" validate:"required"`
	ClaimedAmount    float64   `json:"claimed_amount" validate:"required,gt=0"`
	IncidentLocation string    `json:"incident_location" validate:"required"`
	ContactPhone     string    `json:"contact_phone" validate:"required"`
	ContactEmail     string    `json:"contact_email" validate:"required,email"`
}

// UpdateClaimRequest represents the request payload for updating an existing claim
type UpdateClaimRequest struct {
	Status           *ClaimStatus `json:"status,omitempty" validate:"omitempty,oneof=pending reviewing approved rejected closed"`
	Description      *string      `json:"description,omitempty"`
	ClaimedAmount    *float64     `json:"claimed_amount,omitempty" validate:"omitempty,gt=0"`
	ApprovedAmount   *float64     `json:"approved_amount,omitempty" validate:"omitempty,gte=0"`
	IncidentLocation *string      `json:"incident_location,omitempty"`
	ContactPhone     *string      `json:"contact_phone,omitempty"`
	ContactEmail     *string      `json:"contact_email,omitempty" validate:"omitempty,email"`
	AssignedAdjuster *string      `json:"assigned_adjuster,omitempty"`
}

// ClaimListResponse represents the response for listing claims
type ClaimListResponse struct {
	Claims     []Claim `json:"claims"`
	TotalCount int64   `json:"total_count"`
	Page       int     `json:"page"`
	Limit      int     `json:"limit"`
	TotalPages int     `json:"total_pages"`
}

// ClaimStatsResponse represents claim statistics
type ClaimStatsResponse struct {
	TotalClaims    int64   `json:"total_claims"`
	PendingClaims  int64   `json:"pending_claims"`
	ApprovedClaims int64   `json:"approved_claims"`
	RejectedClaims int64   `json:"rejected_claims"`
	TotalAmount    float64 `json:"total_amount"`
	ApprovedAmount float64 `json:"approved_amount"`
}

// TableName returns the table name for the Claim model
func (Claim) TableName() string {
	return "claims"
}

// TableName returns the table name for the Customer model
func (Customer) TableName() string {
	return "customers"
}

// TableName returns the table name for the Document model
func (Document) TableName() string {
	return "documents"
}

// TableName returns the table name for the ClaimHistory model
func (ClaimHistory) TableName() string {
	return "claim_history"
}
