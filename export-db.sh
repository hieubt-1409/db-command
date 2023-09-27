#!/bin/bash

set -e

if [ $# -lt 2 ]; then
 echo 'export-db.sh [ssh_host] [mysql_service] [output?]'
 exit 1
fi

SSH_HOST="$1"
MYSQL_SERVICE="$2"
OUTFILE=${3:-db}

outfile_basename=$(basename -- $OUTFILE)
outfile_ext="${outfile_basename##*.}"

if [ "$outfile_ext" = gz ]; then
  gzip="| gzip"
else
  gzip=""
fi

mysql_container=$(ssh $SSH_HOST "docker ps | grep $MYSQL_SERVICE | tail -1 | awk '{print \$NF}'")

ssh $SSH_HOST "docker exec $mysql_container bash -c 'mysqldump -u \$MYSQL_USER -p\$MYSQL_PASSWORD \$MYSQL_DATABASE' $gzip" > $OUTFILE
