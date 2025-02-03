#!/bin/bash

set -e

export $(grep -v '^#' hadoop.env| xargs)

docker compose down -v

if docker volume ls -q | grep -wq "hadoop-data"; then
    docker volume rm hadoop-data
fi

if docker volume ls -q | grep -wq "hadoop-namenode"; then
    docker volume rm hadoop-namenode
fi


# Create required Docker volumes
docker volume create hadoop-data
docker volume create hadoop-namenode

# Define the template
TEMPLATE="
CLUSTER_NAME=<testName>
CORE_CONF_fs_defaultFS=<endpoint>
CORE_CONF_hadoop_http_staticuser_user=<user>
HDFS_CONF_dfs_webhdfs_enabled=<boolean>
HDFS_CONF_dfs_permissions_enabled=<boolean>
HDFS_CONF_dfs_namenode_datanode_registration_ip_hostname_check=<boolean>
"

# Extract variable names from the template
TEMPLATE_VARS=$(echo "$TEMPLATE" | grep -o '^[^=]*')

# Create hadoop.env if it doesn't exist
if [ ! -f hadoop.env ]; then
    echo "Creating hadoop.env file..."
    echo "$TEMPLATE" > hadoop.env
    echo "hadoop.env created. Please update authentication variables before proceeding!"
    exit 1
else
    MISSING_LINES=""
    for var in $TEMPLATE_VARS; do
        if ! grep -q "^$var=" hadoop.env; then
            missing_line=$(echo "$TEMPLATE" | grep -E "^$var=")
            MISSING_LINES+="$missing_line"$'\n'
        fi
    done

    # Append missing lines if necessary
    if [ -n "$MISSING_LINES" ]; then
        echo -e "$MISSING_LINES" >> hadoop.env
        echo "Missing configurations have been added to hadoop.env. Please update authentication variables!"
        exit 1
    fi
fi

# Function to validate environment variables
validate_env() {
    local var_name="$1"
    local var_value="$2"

    # Check if the value contains "<...>"
    if echo "$var_value" | grep -qE '^<.*>$'; then
        echo "❌ ERROR: $var_name contains an invalid placeholder value: $var_value"
        echo "⚠️  Please update hadoop.env with valid credentials before proceeding!"
        exit 1
    fi
}

# Validate each required variable
validate_env "CLUSTER_NAME" "$CLUSTER_NAME"
validate_env "CORE_CONF_fs_defaultFS" "$CORE_CONF_fs_defaultFS"
validate_env "CORE_CONF_hadoop_http_staticuser_user" "$CORE_CONF_hadoop_http_staticuser_user"
validate_env "HDFS_CONF_dfs_webhdfs_enabled" "$HDFS_CONF_dfs_webhdfs_enabled"
validate_env "HDFS_CONF_dfs_permissions_enabled" "$HDFS_CONF_dfs_permissions_enabled"
validate_env "HDFS_CONF_dfs_namenode_datanode_registration_ip_hostname_check" "$HDFS_CONF_dfs_namenode_datanode_registration_ip_hostname_check"

echo "> ✅ Variable validated. Proceeding with cluster setup..."

source ./hadoop.env
echo ".........."
echo "..............."
echo "......................"
echo "..........................."
echo "> ✅ Starting Hadoop cluster..."
docker compose up -d

# Wait for services to be ready
echo "> Waiting for services to be ready..."
sleep 30
# Format Namenode with automatic "Y" response
echo "Formatting namenode..."
docker exec -i namenode bash -c 'echo "Y" | hdfs namenode -format'
# Restart services after format
docker compose restart
echo "✅ Hadoop cluster is ready!"
echo "🌍 You can access the Hadoop UI at http://localhost:9870"
