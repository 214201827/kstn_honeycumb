#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
mysqldump -u${MARIADB_USER} -p${MARIADB_PASSWORD} -h${DB_HOST} ${MARIADB_DATABASE} > /backups/backup-${TIMESTAMP}.sql
