# Export DB

```sh
./export-db.sh [ssh_host] [mysql_service] [file?]
```

Example

```sh
# Export to db.sql.gz
./export-db.sh review-staging review_system_mariadb

# Export to db_[current date].sql.gz
./export-db.sh review-staging review_system_mariadb db_$(date '+%d%m%Y').sql.gz
```

# Import DB

```sh
./import-db.sh [mysql_service] [db_name] [sql_file]
```

Example

```sh
./import-db.sh review_mysql dev_$(date '+%d%m%Y') db_staging.sql.gz
```
