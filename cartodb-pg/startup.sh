#!/bin/sh

# Check for initial database
if [ ! -d /var/lib/postgresql/10 ] ; then
  echo "Bootstrapping database"
  cp -r /opt/db_bootstrap/10 /var/lib/postgresql/
fi

/usr/lib/postgresql/10/bin/postgres -D /var/lib/postgresql/10/main -c config_file=/etc/postgresql/10/main/postgresql.conf
