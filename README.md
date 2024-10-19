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



## Build from source

Using docker


```

# Linux ARM
export os=linux arch=arm64 version=$(git tag --points-at HEAD); docker run --rm -it -u "$(id -u):$(id -g)" -v "${PWD}:/xk6" --platform linux/amd64 -e  GOOS=$os -e GOARCH=$arch grafana/xk6 build latest --output k6-$os-$arch-$version --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=/xk6

# Linux x86
export os=linux arch=amd64 version=$(git tag --points-at HEAD); docker run --rm -it -u "$(id -u):$(id -g)" -v "${PWD}:/xk6" --platform linux/amd64 -e  GOOS=$os -e GOARCH=$arch grafana/xk6 build latest --output k6-$os-$arch-$version --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=/xk6


# MacOS ARM
export os=darwin arch=arm64 version=$(git tag --points-at HEAD); docker run --rm -it -u "$(id -u):$(id -g)" -v "${PWD}:/xk6" --platform linux/amd64 -e  GOOS=$os -e GOARCH=$arch grafana/xk6 build latest --output k6-$os-$arch-$version --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=/xk6


# MacOS x86
export os=darwin arch=amd64 version=$(git tag --points-at HEAD); docker run --rm -it -u "$(id -u):$(id -g)" -v "${PWD}:/xk6" --platform linux/amd64 -e  GOOS=$os -e GOARCH=$arch grafana/xk6 build latest --output k6-$os-$arch-$version --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=/xk6

# Windows ARM Binary
export os=windows arch=arm64 version=$(git tag --points-at HEAD); docker run --rm -it -u "$(id -u):$(id -g)" -v "${PWD}:/xk6" --platform linux/amd64 -e  GOOS=$os -e GOARCH=$arch grafana/xk6 build latest --output k6-$os-$arch-$version --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=/xk6

# Windows x86 Binary
export os=windows arch=amd64 version=$(git tag --points-at HEAD);  docker run --rm -it -u "$(id -u):$(id -g)" -v "${PWD}:/xk6" --platform linux/amd64 -e  GOOS=$os -e GOARCH=$arch grafana/xk6 build latest --output k6-$os-$arch-$version./ --with github.com/grafana/xk6-sql@latest --with github.com/yogendra/xk6-sql-driver-yugabytedb@latest=/xk6


```
