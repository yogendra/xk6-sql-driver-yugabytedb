# xk6-sql-driver-yugabyte

Database driver extension for [xk6-sql](https://github.com/grafana/xk6-sql) k6 extension to support [YugabyteDB](https://www.yugabyte.com) database.

## Example

```JavaScript file=examples/example.js
import sql from "k6/x/sql";
import driver from "k6/x/sql/driver/pgx"

const db = sql.open(driver, "postgres://yugabyte:yugabyte@localhost:5433/yugabyte?load_balance=true&sslmode=disable");

export function setup() {
  db.exec(`DROP TABLE IF EXISTS namevalue;`)
  db.exec(`CREATE TABLE IF NOT EXISTS namevalue (
             id serial,
             name VARCHAR NOT NULL,
             value VARCHAR,
             primary key (id HASH)
           ) SPLIT INTO 1 TABLETS;`);
}

export function teardown() {
  db.close();
}

export default function () {
  db.exec("INSERT INTO namevalue (name, value) VALUES('extension-name', 'xk6-foo');");

  let results = sql.query(db, "SELECT * FROM namevalue WHERE name = $1;", "extension-name");
  for (const row of results) {
    console.log(`name: ${row.name}, value: ${row.value}`);
  }
}

```

## Usage

Check the [xk6-sql documentation](https://github.com/grafana/xk6-sql) on how to use this database driver.
