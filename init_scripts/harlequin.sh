#!/usr/bin/env bash

apt-get install -y unixodbc
source "$HOME/.local/bin/env"
uv tool install 'harlequin[postgres,mysql,s3,sqlite,odbc,duckdb]'
