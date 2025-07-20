package middleware

import (
	"fmt"
	"math/rand"
	"time"

	"github.com/gin-gonic/gin"
)

// Logger returns a logging middleware
func Logger() gin.HandlerFunc {
	return gin.Logger()
}

// Recovery returns a recovery middleware
func Recovery() gin.HandlerFunc {
	return gin.Recovery()
}

// CORS returns a CORS middleware
func CORS() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Origin, Content-Type, Accept, Authorization")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

// Security returns a security headers middleware
func Security() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("X-Frame-Options", "DENY")
		c.Header("X-Content-Type-Options", "nosniff")
		c.Header("X-XSS-Protection", "1; mode=block")
		c.Header("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
		c.Next()
	}
}

// RequestID returns a request ID middleware
func RequestID() gin.HandlerFunc {
	return func(c *gin.Context) {
		requestID := c.GetHeader("X-Request-ID")
		if requestID == "" {
			// Simple ID generation without external dependencies
			requestID = fmt.Sprintf("req-%d-%d", time.Now().UnixNano(), rand.Intn(1000))
		}
		c.Header("X-Request-ID", requestID)
		c.Set("request_id", requestID)
		c.Next()
	}
}
