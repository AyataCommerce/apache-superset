#!/bin/bash
set -eo pipefail

#=================#
#   PRINTING      #
# ENVs Variables  #
#=================#

if [[ -n "$DATABASE_PORT" && -n "$DATABASE_HOST" && -n "$DATABASE_DIALECT" && -n "$DATABASE_DB" && -n "$DATABASE_USER" && -n "$DATABASE_PASSWORD" ]]

then
  echo Exporting DATABASE_URL environment variable
  export SQLALCHEMY_DATABASE_URI="$DATABASE_DIALECT://$DATABASE_USER:$DATABASE_PASSWORD@$DATABASE_HOST:$DATABASE_PORT/$DATABASE_DB"
  echo $SQLALCHEMY_DATABASE_URI

else
  echo "Required ENV Variables are not set"

fi

"$@"