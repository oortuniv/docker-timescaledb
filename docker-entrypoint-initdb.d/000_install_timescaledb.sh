#!/bin/bash

psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS timescaledb"
psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS timescaledb_toolkit"