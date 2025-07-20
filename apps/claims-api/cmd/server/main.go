package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"claims-api/internal/database"
	"claims-api/internal/handlers"
	"claims-api/internal/middleware"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/sirupsen/logrus"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		logrus.Warn("No .env file found")
	}

	// Configure logging
	setupLogging()

	// Initialize database (mock for local development)
	db, err := database.Initialize()
	if err != nil {
		logrus.Warnf("Database initialization failed, using mock mode: %v", err)
		// Continue with mock database for demo
	}

	// Setup Gin router
	router := setupRouter(db)

	// Setup graceful shutdown
	srv := &http.Server{
		Addr:    ":" + getEnv("PORT", "8080"),
		Handler: router,
	}

	// Start server
	go func() {
		logrus.Infof("Starting server on port %s", getEnv("PORT", "8080"))
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logrus.Fatalf("Failed to start server: %v", err)
		}
	}()

	// Wait for interrupt signal to gracefully shutdown the server
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	logrus.Info("Shutting down server...")

	// Give outstanding requests a 30-second grace period
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		logrus.Fatalf("Server forced to shutdown: %v", err)
	}

	logrus.Info("Server exited")
}

func setupLogging() {
	logrus.SetFormatter(&logrus.JSONFormatter{})
	logrus.SetLevel(logrus.InfoLevel)

	if getEnv("LOG_LEVEL", "info") == "debug" {
		logrus.SetLevel(logrus.DebugLevel)
	}
}

func setupRouter(db *database.DB) *gin.Engine {
	// Set Gin mode
	if getEnv("GIN_MODE", "debug") == "release" {
		gin.SetMode(gin.ReleaseMode)
	}

	router := gin.New()

	// Add middleware
	router.Use(middleware.Logger())
	router.Use(middleware.Recovery())
	router.Use(middleware.CORS())
	router.Use(middleware.Security())
	router.Use(middleware.RequestID())

	// Health check endpoints
	router.GET("/health", handlers.HealthCheck(db))
	router.GET("/ready", handlers.ReadinessCheck(db))

	// Metrics endpoint for Prometheus
	router.GET("/metrics", gin.WrapH(promhttp.Handler()))

	// Initialize handlers
	claimHandler := handlers.NewClaimHandler(db)
	customerHandler := handlers.NewCustomerHandler(db)

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Claims routes
		claims := v1.Group("/claims")
		{
			claims.GET("", claimHandler.GetClaims)
			claims.POST("", claimHandler.CreateClaim)
			claims.GET("/:id", claimHandler.GetClaim)
			claims.PUT("/:id", claimHandler.UpdateClaim)
			claims.DELETE("/:id", claimHandler.DeleteClaim)
			claims.GET("/stats", claimHandler.GetClaimStats)
			claims.POST("/:id/documents", claimHandler.UploadDocument)
			claims.GET("/:id/history", claimHandler.GetClaimHistory)
		}

		// Customers routes
		customers := v1.Group("/customers")
		{
			customers.GET("", customerHandler.GetCustomers)
			customers.POST("", customerHandler.CreateCustomer)
			customers.GET("/:id", customerHandler.GetCustomer)
			customers.PUT("/:id", customerHandler.UpdateCustomer)
			customers.DELETE("/:id", customerHandler.DeleteCustomer)
			customers.GET("/:id/claims", customerHandler.GetCustomerClaims)
		}
	}

	return router
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
