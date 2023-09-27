#!/bin/bash

set -e

if [ $# -eq 3 ]; then
  MYSQL_SERVICE=$1
  DB="$2"
  INPUT=$3
else
  echo 'import-db.sh [db_service] [db_name] [sql_file]'
  exit 1
fi

mysql_container=$(docker ps | grep $MYSQL_SERVICE | tail -1 | awk '{print $NF}')

USER=$(docker exec $mysql_container bash -c 'echo $MYSQL_USER')

cat <<EOF | docker exec -i "$mysql_container" bash -c 'mysql -u root -p$MYSQL_ROOT_PASSWORD'
CREATE DATABASE IF NOT EXISTS $DB;
GRANT ALL PRIVILEGES ON $DB.* TO '$USER'@'%';
EOF

sql_filename=$(basename -- $INPUT)
sql_ext="${sql_filename##*.}"

if [ "$sql_ext" = gz ]; then
  cat_cmd=gunzip
else
  cat_cmd=cat
fi

$cat_cmd < "$INPUT" | docker exec -i $mysql_container bash -c "mysql -f -u \"\$MYSQL_USER\" -p\"\$MYSQL_PASSWORD\" $DB"
