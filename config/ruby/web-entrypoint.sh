#!/bin/bash

# TODO customizable

# db container alias (it is added to /etc/hosts)
DB_HOST='database'
DB_PORT=5432
TIMEOUT=20
SPENT=0
TRIES=10
WAIT_SECONDS=3

# TODO catch signals?

echo -e "\n\t » Using '$RAILS_ENV' environment"

echo -e "\t » Connecting to PostgreSQL"

while ! PGPASSWORD=$DATABASE_ENV_POSTGRES_PASSWORD psql --host=$DATABASE_PORT_5432_TCP_ADDR --username=$DATABASE_ENV_POSTGRES_USER --dbname=$DATABASE_ENV_POSTGRES_DB; do
  sleep 1
  echo -e "\t  ..."
  SPENT=`expr $SPENT + 1`
  if [[ $TIMEOUT = $SPENT ]]; then
		echo -e "\n\t » Timeout after $SPENT seconds"
		exit 1
  fi
done

RAILS_DB_VERSION=`/ruby/web/bin/rake db:version`
echo -e "\t » Rails DB version: $RAILS_DB_VERSION"

# bin/rake db:version || { bundle exec rake db:setup; }
if [[ $RAILS_DB_VERSION = 'Current version: 0' ]]; then
  echo -e "\t » Creating up the database"
  /ruby/web/bin/rake db:create
fi

echo -e "\t » Migrating the database"
/ruby/web/bin/rake db:migrate

# TODO seed
# /ruby/web/bin/rake db:seed

# bin/rake tmp:clear

# TODO precompile option
# if [[ $RAILS_ENV = 'production' ]]; then
/ruby/web/bin/rake assets:precompile
# fi

exec "$@"
