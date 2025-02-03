#!/bin/bash

# Download and setup Hadoop
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xzf hadoop-3.3.6.tar.gz
mv hadoop-3.3.6 /opt/hadoop
rm hadoop-3.3.6.tar.gz

# Set environment variables
export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Configure Hadoop
cat > $HADOOP_CONF_DIR/core-site.xml <<EOL
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://namenode:9000</value>
    </property>
</configuration>
EOL

cat > $HADOOP_CONF_DIR/hdfs-site.xml <<EOL
<?xml version="1.0"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/hadoop/dfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/hadoop/dfs/data</value>
    </property>
</configuration>
EOL

# Start datanode
$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode

# Keep container running
tail -f /dev/null