// Package yugabytedb contains YugabyteDB driver registration for xk6-sql.
package yugabytedb

import (
	_ "database/sql"

	"github.com/grafana/xk6-sql/sql"

	// Blank import required for initialization of driver.
	_ "github.com/yugabyte/pgx/v5/stdlib"
)

func init() {
	sql.RegisterModule("pgx")
}
