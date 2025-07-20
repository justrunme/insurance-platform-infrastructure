package handlers

import (
	"net/http"
	"strconv"

	"claims-api/internal/database"

	"github.com/gin-gonic/gin"
)

// ClaimHandler handles claim-related HTTP requests
type ClaimHandler struct {
	db *database.DB
}

// NewClaimHandler creates a new claim handler
func NewClaimHandler(db *database.DB) *ClaimHandler {
	return &ClaimHandler{
		db: db,
	}
}

// GetClaims returns a list of claims with pagination
func (h *ClaimHandler) GetClaims(c *gin.Context) {
	// Mock data for demo
	claims := []map[string]interface{}{
		{
			"id":            1,
			"claim_number":  "CLM-2024-001",
			"status":        "pending",
			"amount":        5000.00,
			"customer_name": "John Doe",
		},
		{
			"id":            2,
			"claim_number":  "CLM-2024-002",
			"status":        "approved",
			"amount":        2500.00,
			"customer_name": "Jane Smith",
		},
	}

	c.JSON(http.StatusOK, gin.H{
		"claims":      claims,
		"total_count": len(claims),
		"page":        1,
		"limit":       10,
	})
}

// CreateClaim creates a new insurance claim
func (h *ClaimHandler) CreateClaim(c *gin.Context) {
	var request map[string]interface{}
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Mock creation
	c.JSON(http.StatusCreated, gin.H{
		"message":  "Claim created successfully",
		"claim_id": 123,
		"status":   "pending",
	})
}

// GetClaim returns a specific claim by ID
func (h *ClaimHandler) GetClaim(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid claim ID"})
		return
	}

	// Mock data
	claim := map[string]interface{}{
		"id":            id,
		"claim_number":  "CLM-2024-001",
		"status":        "pending",
		"amount":        5000.00,
		"customer_name": "John Doe",
		"description":   "Car accident on highway",
	}

	c.JSON(http.StatusOK, claim)
}

// UpdateClaim updates an existing claim
func (h *ClaimHandler) UpdateClaim(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid claim ID"})
		return
	}

	var request map[string]interface{}
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":  "Claim updated successfully",
		"claim_id": id,
	})
}

// DeleteClaim soft deletes a claim
func (h *ClaimHandler) DeleteClaim(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid claim ID"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":  "Claim deleted successfully",
		"claim_id": id,
	})
}

// GetClaimStats returns claim statistics
func (h *ClaimHandler) GetClaimStats(c *gin.Context) {
	stats := map[string]interface{}{
		"total_claims":    150,
		"pending_claims":  45,
		"approved_claims": 85,
		"rejected_claims": 20,
		"total_amount":    750000.00,
		"approved_amount": 425000.00,
	}

	c.JSON(http.StatusOK, stats)
}

// UploadDocument uploads a document for a claim
func (h *ClaimHandler) UploadDocument(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid claim ID"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":     "Document uploaded successfully",
		"claim_id":    id,
		"document_id": 456,
	})
}

// GetClaimHistory returns the history of changes for a claim
func (h *ClaimHandler) GetClaimHistory(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid claim ID"})
		return
	}

	history := []map[string]interface{}{
		{
			"id":         1,
			"action":     "created",
			"changed_by": "system",
			"timestamp":  "2024-01-15T10:00:00Z",
		},
		{
			"id":         2,
			"action":     "status_updated",
			"old_value":  "pending",
			"new_value":  "reviewing",
			"changed_by": "adjuster@company.com",
			"timestamp":  "2024-01-16T14:30:00Z",
		},
	}

	c.JSON(http.StatusOK, gin.H{
		"claim_id": id,
		"history":  history,
	})
}
