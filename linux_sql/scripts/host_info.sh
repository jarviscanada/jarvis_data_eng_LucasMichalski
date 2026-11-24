#!/bin/bash

# validate arguments
if [ "$#" -ne 5 ]; then
    echo "Error: Expected 5 arguments"
    echo "Usage: $0 psql_host psql_port db_name psql_user psql_password"
    exit 1
fi

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

hostname=$(hostname -f)

# hardware info
cpu_number=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
cpu_architecture=$(lscpu | grep '^Architecture:' | awk '{print $2}')
cpu_model=$(lscpu | grep '^Model name:' | cut -d ':' -f2- | xargs)
cpu_mhz=$(grep -m 1 'cpu MHz' /proc/cpuinfo | awk '{print $4}')
l2_cache=$(lscpu | grep '^L2 cache:' | awk '{print $3}' | sed 's/[^0-9.]//g')
total_mem=$(free -m | awk '/^Mem:/ {print $2}')
timestamp=$(date -u '+%Y-%m-%d %H:%M:%S')

# construct sql insert
insert_stmt="INSERT INTO host_info (
    hostname,
    cpu_number,
    cpu_architecture,
    cpu_model,
    cpu_mhz,
    l2_cache,
    timestamp,
    total_mem
) VALUES (
    '$hostname',
    $cpu_number,
    '$cpu_architecture',
    '$cpu_model',
    $cpu_mhz,
    $l2_cache,
    '$timestamp',
    $total_mem
);"

export PGPASSWORD="$psql_password"

# send query to postgres instance
psql -h "$psql_host" -p "$psql_port" -U "$psql_user" -d "$db_name" -c "$insert_stmt"

exit $?
