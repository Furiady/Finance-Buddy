## Basic Usage

New
```shell
$ go run main.go new --types <mysql|postgre> --name <migration-name>
```
Migrate
```shell
$ go run main.go migrate [--types <mysql,postgre>] [--version <VERSION>] [--verbose] [--specific]
```
Rollback
```shell
$ go run main.go rollback --version <VERSION> [--types <mysql,postgre>] [--verbose] [--specific]
```