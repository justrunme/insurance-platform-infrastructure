package handlers

import (
	"net/http"
	"strconv"

	"claims-api/internal/database"

	"github.com/gin-gonic/gin"
)

// CustomerHandler handles customer-related HTTP requests
type CustomerHandler struct {
	db *database.DB
}

// NewCustomerHandler creates a new customer handler
func NewCustomerHandler(db *database.DB) *CustomerHandler {
	return &CustomerHandler{
		db: db,
	}
}

// GetCustomers returns a list of customers with pagination
func (h *CustomerHandler) GetCustomers(c *gin.Context) {
	// Mock data for demo
	customers := []map[string]interface{}{
		{
			"id":         1,
			"first_name": "John",
			"last_name":  "Doe",
			"email":      "john.doe@email.com",
			"phone":      "+1-555-0123",
		},
		{
			"id":         2,
			"first_name": "Jane",
			"last_name":  "Smith",
			"email":      "jane.smith@email.com",
			"phone":      "+1-555-0456",
		},
	}

	c.JSON(http.StatusOK, gin.H{
		"customers":   customers,
		"total_count": len(customers),
		"page":        1,
		"limit":       10,
	})
}

// CreateCustomer creates a new customer
func (h *CustomerHandler) CreateCustomer(c *gin.Context) {
	var request map[string]interface{}
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message":     "Customer created successfully",
		"customer_id": 123,
	})
}

// GetCustomer returns a specific customer by ID
func (h *CustomerHandler) GetCustomer(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid customer ID"})
		return
	}

	// Mock data
	customer := map[string]interface{}{
		"id":         id,
		"first_name": "John",
		"last_name":  "Doe",
		"email":      "john.doe@email.com",
		"phone":      "+1-555-0123",
		"address":    "123 Main St, City, State",
	}

	c.JSON(http.StatusOK, customer)
}

// UpdateCustomer updates an existing customer
func (h *CustomerHandler) UpdateCustomer(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid customer ID"})
		return
	}

	var request map[string]interface{}
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":     "Customer updated successfully",
		"customer_id": id,
	})
}

// DeleteCustomer soft deletes a customer
func (h *CustomerHandler) DeleteCustomer(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid customer ID"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":     "Customer deleted successfully",
		"customer_id": id,
	})
}

// GetCustomerClaims returns all claims for a specific customer
func (h *CustomerHandler) GetCustomerClaims(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid customer ID"})
		return
	}

	// Mock claims data
	claims := []map[string]interface{}{
		{
			"id":            1,
			"claim_number":  "CLM-2024-001",
			"status":        "pending",
			"amount":        5000.00,
			"incident_date": "2024-01-10",
		},
		{
			"id":            2,
			"claim_number":  "CLM-2024-002",
			"status":        "approved",
			"amount":        2500.00,
			"incident_date": "2024-01-05",
		},
	}

	c.JSON(http.StatusOK, gin.H{
		"customer_id": id,
		"claims":      claims,
		"total_count": len(claims),
	})
}
