// Package ramsql contains RamSQL driver registration for xk6-sql.
package ramsql

import (
	"github.com/grafana/xk6-sql/sql"

	// Blank import required for initialization of driver.
	_ "github.com/yugabyte/pgx/v5"
)

func init() {
	sql.RegisterModule("yugabytedb")
}
