#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start docker
sudo systemctl status docker || sudo systemctl start docker

# Check container status
docker container inspect jrvs-psql
container_status=$?

# Use switch case to handle create|stop|start options
case $cmd in
  create)

    # Check if the container is already created
    if [ $container_status -eq 0 ]; then
      echo 'Container already exists'
      exit 1
    fi

    # Check # of CLI arguments
    if [ $# -ne 3 ]; then
      echo 'Create requires username and password'
      exit 1
    fi

    # Create volume
    docker volume create pgdata

    # Create and start the container
    docker run --name jrvs-psql \
      -e POSTGRES_USER="$db_username" \
      -e POSTGRES_PASSWORD="$db_password" \
      -d \
      -v pgdata:/var/lib/postgresql/data \
      -p 127.0.0.1:5432:5432 \
      postgres:17-alpine

    exit $?
    ;;

  start|stop)

    # Check if container exists
    if [ $container_status -ne 0 ]; then
      echo 'Container does not exist'
      exit 1
    fi

    # Start or stop the container
    docker container $cmd jrvs-psql
    exit $?
    ;;

  *)
    echo 'Illegal command'
    echo 'Commands: start|stop|create'
    exit 1
    ;;
esac

