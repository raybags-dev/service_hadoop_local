#!/bin/bash
set -e
# Stop and remove old containers
docker compose down -v

# Create required Docker volumes
docker volume create hadoop-data
docker volume create hadoop-namenode

# Create hadoop.env if it doesn't exist
if [ ! -f hadoop.env ]; then
    cat > hadoop.env <<EOL
CORE_CONF_fs_defaultFS=hdfs://namenode:9000
CORE_CONF_hadoop_http_staticuser_user=root
HDFS_CONF_dfs_webhdfs_enabled=true
HDFS_CONF_dfs_permissions_enabled=false
HDFS_CONF_dfs_namenode_datanode_registration_ip-hostname-check=false
EOL
fi

# Start Hadoop cluster
docker compose up -d

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 30

# Format Namenode with automatic "Y" response
echo "Formatting namenode..."
docker exec -i namenode bash -c 'echo "Y" | hdfs namenode -format'

# Restart services after format
docker compose restart

echo "Hadoop cluster is ready!"
echo "You can access the Hadoop UI at http://localhost:9870"
