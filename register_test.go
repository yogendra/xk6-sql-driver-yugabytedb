package yugabytedb

import (
	"context"
	_ "embed"
	"fmt"
	"testing"

	"github.com/grafana/xk6-sql/sqltest"
	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go/modules/yugabytedb"
)

//go:embed testdata/script.js
var script string

func TestIntegration(t *testing.T) { //nolint:paralleltest

  if testing.Short() {
		t.Skip()
	}
	// if runtime.GOOS != "linux" {
	// 	t.Skip("Works only on Linux (Testcontainers)")
	// }
	ctx := context.Background()

	ctr, err := yugabytedb.Run(ctx,"yugabytedb/yugabyte:2024.1.3.0-b105")

  require.NoError(t, err)

  defer func() { require.NoError(t, ctr.Terminate(ctx)) }()

	// conn, err := ctr.YSQLConnectionString(ctx, "sslmode=disable", "load_balance=true")
  mapperPort, err := ctr.MappedPort(ctx, "5433/tcp")
  require.NoError(t, err)
  conn := fmt.Sprintf("postgres://yugabyte:yugabyte@localhost:%s/yugabyte?sslmode=disable&load_balance=false", mapperPort.Port() );
  println("Connection String: ", conn)

	sqltest.RunScript(t, "pgx", conn, script)
}
