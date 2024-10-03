#!/bin/bash
sleep 15
/usr/bin/mysqldump -h db -u keystone -pkeystone honeycumb > /backups/backup_$(date +'%Y%m%d_%H%M%S').sql
while true; do
  /usr/bin/mysqldump -h db -u keystone -pkeystone honeycumb > /backups/backup_$(date +'%Y%m%d_%H%M%S').sql
  sleep 86400  # Respaldo diario
done
