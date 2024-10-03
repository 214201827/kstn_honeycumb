#!/bin/sh
while true; do
  /usr/bin/mysqldump -u keystone -pkeystone honeycumb > /backups/backup_$(date +'%Y%m%d_%H%M%S').sql
  sleep 86400  # Espera 24 horas
done
