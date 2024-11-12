#!/bin/bash
if mysqladmin ping -h db > /dev/null 2>&1; then
  if mysql -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" -e "USE $MARIADB_DATABASE; SELECT 1 FROM usuarios LIMIT 1;" > /dev/null 2>&1; then
    exit 0
  fi
fi
exit 1
