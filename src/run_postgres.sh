#!/bin/bash

mkdir /run/postgresql
chown -R postgres:postgres /run/postgresql
mkdir -p /woongzz0110/timescaledb/data
chown -R postgres:postgres /woongzz0110/timescaledb
su postgres -c "/usr/bin/pg_ctl init -D ${PG_DATA}"
su postgres -c "/usr/bin/pg_ctl start -D ${PG_DATA}"