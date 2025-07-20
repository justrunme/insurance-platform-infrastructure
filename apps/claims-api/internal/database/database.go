package database

import (
	"fmt"
)

// DB wraps a mock database connection for demo
type DB struct {
	connected bool
}

// Initialize creates a mock database connection for demo
func Initialize() (*DB, error) {
	// For demo purposes, we'll create a mock connection
	// In production, this would connect to real PostgreSQL

	fmt.Println("Initializing mock database connection for demo...")

	return &DB{
		connected: true,
	}, nil
}

// HealthCheck performs a basic health check on the mock database
func (db *DB) HealthCheck() error {
	if !db.connected {
		return fmt.Errorf("database connection not available")
	}
	return nil
}

// Close closes the mock database connection
func (db *DB) Close() error {
	db.connected = false
	return nil
}

// GetStats returns mock database connection statistics
func (db *DB) GetStats() (map[string]interface{}, error) {
	return map[string]interface{}{
		"max_open_connections": 100,
		"open_connections":     5,
		"in_use":               2,
		"idle":                 3,
		"status":               "mock",
	}, nil
}
