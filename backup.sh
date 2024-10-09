#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
MARIADB_USER="keystone"
MARIADB_PASSWORD="keystone"
DB_HOST="db"
MARIADB_DATABASE="honeycumb"
mysqldump -u${MARIADB_USER} -p${MARIADB_PASSWORD} -h${DB_HOST} ${MARIADB_DATABASE} > /backups/backup-${TIMESTAMP}.sql
