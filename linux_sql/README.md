# Linux Cluster Monitoring Agent
This project is under development. Since this project follows the GitFlow, the final work will be merged to the main branch after Team Code Team.
## Introduction
The Linux Cluster Monitoring Agent is a Minimum Viable Product (MVP) developed to support the Jarvis Linux Cluster Administration (LCA) team with infrastructure monitoring which can be used in LCA reports to inform future resource planning.

The MVP was implemented and tested on a single Rocky Linux host, using Bash scripts to collect hardware information, and CPU and memory usage metrics. Docker provides the PostgreSQL database environment, while cron automates collection of Linux host usage data at one-minute intervals. Git and GitHub are used for version control and source code management.

The architecture is designed to scale across multiple Linux hosts by deploying the monitoring agents on additional servers.
## Quick Start
### Docker
Docker is required for this project. Please verify docker is installed on the Linux host using `docker --version`. If docker is not installed, please follow the [Official Docker installation instructions for RHEL-based Linux](https://docs.docker.com/engine/install/rhel).
### Initializing PostgreSQL
Run the following command from within the linux_sql directory:
```
./scripts/psql_docker.sh create <db_username> <db_password>
```
The above script provisions a Docker container named jrvs-psql and a persistent volume named pgdata.\
PostgreSQL is accessible locally at 127.0.0.1:5432.

To verify the container is running:
```
docker ps
```

Managing an existing container:
```
# Start
bash scripts/psql_docker.sh start

# Stop
bash scripts/psql_docker.sh stop
```

### Creating Tables
Create the application database
```
# Create the application database
psql -h localhost -U postgres -d postgres -c "CREATE DATABASE host_agent;"

# Create tables in the application database
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql
```

### Host Info
Host info is collected once at project setup. To collect the Linux host hardware data, run the following command:
```
bash scripts/host_info.sh 127.0.0.1 5432 host_agent postgres {password}
```
#### Host Usage
Host Usage is collected periodically through the use of a cron job. 
```
* * * * * bash /home/rocky/dev/jarvis_data_eng_LucasMichalski/linux_sql/scripts/host_usage.sh 127.0.0.1 5432 host_agent postgres "" > /home/rocky/host_usage_cron.log 2>&1
```
