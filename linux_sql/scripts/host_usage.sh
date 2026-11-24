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

# host usage
vmstat_mb=$(vmstat --unit M 1 2 | tail -n 1)
memory_free=$(echo "$vmstat_mb" | awk '{print $4}')
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $14}')
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}')
disk_io=$(vmstat -d | awk '$1 == "sda" {print $11}')
disk_available=$(df -BM / | awk 'NR==2 {print $4}' | tr -d 'M')

hostname=$(hostname -f)
timestamp=$(date -u '+%Y-%m-%d %H:%M:%S')

# set host_id for foreign key
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"

# construct sql insert
insert_stmt="INSERT INTO host_usage (
    timestamp,
    host_id,
    memory_free,
    cpu_idle,
    cpu_kernel,
    disk_io,
    disk_available
) VALUES (
    '$timestamp',
    $host_id,
    $memory_free,
    $cpu_idle,
    $cpu_kernel,
    $disk_io,
    $disk_available
);"

export PGPASSWORD="$psql_password"

psql -h "$psql_host" -p "$psql_port" -U "$psql_user" -d "$db_name" -c "$insert_stmt"

exit $?
