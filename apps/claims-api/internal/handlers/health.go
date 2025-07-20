package handlers

import (
	"net/http"
	"os"
	"time"

	"claims-api/internal/database"

	"github.com/gin-gonic/gin"
)

// HealthResponse represents the health check response
type HealthResponse struct {
	Status    string                 `json:"status"`
	Timestamp time.Time              `json:"timestamp"`
	Version   string                 `json:"version"`
	Checks    map[string]interface{} `json:"checks"`
}

// HealthCheck returns a health check endpoint
func HealthCheck(db *database.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		checks := make(map[string]interface{})

		// Database health check
		dbStatus := "healthy"
		if db != nil {
			if err := db.HealthCheck(); err != nil {
				dbStatus = "unhealthy"
				checks["database"] = map[string]interface{}{
					"status": dbStatus,
					"error":  err.Error(),
				}
			} else {
				checks["database"] = map[string]interface{}{
					"status": dbStatus,
				}
			}
		} else {
			checks["database"] = map[string]interface{}{
				"status": "mock",
				"note":   "Using mock database for demo",
			}
		}

		// Overall status
		status := "healthy"
		if dbStatus == "unhealthy" {
			status = "unhealthy"
		}

		response := HealthResponse{
			Status:    status,
			Timestamp: time.Now(),
			Version:   getEnv("APP_VERSION", "1.0.0"),
			Checks:    checks,
		}

		if status == "healthy" {
			c.JSON(http.StatusOK, response)
		} else {
			c.JSON(http.StatusServiceUnavailable, response)
		}
	}
}

// ReadinessCheck returns a readiness check endpoint
func ReadinessCheck(db *database.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Check if database is ready
		if db != nil {
			if err := db.HealthCheck(); err != nil {
				c.JSON(http.StatusServiceUnavailable, gin.H{
					"status":    "not ready",
					"timestamp": time.Now(),
					"error":     err.Error(),
				})
				return
			}
		}

		c.JSON(http.StatusOK, gin.H{
			"status":    "ready",
			"timestamp": time.Now(),
		})
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
