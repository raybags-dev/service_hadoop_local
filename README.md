## Set up Hadoop Cluster with Docker

1. **Install Docker**: If you haven't already, [install Docker](https://docs.docker.com/get-docker/) on your machine.

2. **Create Docker Volumes**: Since we want to map the storage space to your local machine's file system, we need to create Docker volumes for HDFS data and metadata.

   ```bash
   docker volume create hadoop-data
   docker volume create hadoop-namenode
   ```

3. **Start Hadoop Cluster**: Use the following Docker Compose file to start the Hadoop cluster:

   ```yaml
   version: '3'
   services:
     namenode:
       image: bde2020/hadoop-base:latest
       volumes:
         - hadoop-namenode:/hadoop/dfs/name
       environment:
         - CLUSTER_NAME=test
       ports:
         - 9870:9870

     datanode:
       image: bde2020/hadoop-base:latest
       volumes:
         - hadoop-data:/hadoop/dfs/data
       environment:
         - HDFS_CONF_dfs_data_dir_list=/hadoop/dfs/data
         - HDFS_CONF_dfs_datanode_use_datanode_hostname=true
       depends_on:
         - namenode

   volumes:
     hadoop-data:
       external: true
     hadoop-namenode:
       external: true
   ```

   Save this as `docker-compose.yml` and run `docker-compose up -d` to start the cluster.

4. **Verify Cluster**: You can access the Hadoop web UI at `http://localhost:9870` to verify that the cluster is running.

## Integrate Hadoop with Node.js-Express

1. **Install `hadoop-js` library**: In your Node.js project, install the `hadoop-js` library:

   ```bash
   npm install hadoop-js
   ```

2. **Connect to Hadoop Cluster**: In your Node.js-Express server, use the `hadoop-js` library to connect to the Hadoop cluster:

   ```javascript
   const { Client } = require('hadoop-js');

   const client = new Client({
     user: 'root',
     namenode: 'localhost:9000',
     webhdfs: 'http://localhost:9870/webhdfs/v1'
   });
   ```

3. **Interact with HDFS**: You can now use the `client` object to interact with the Hadoop Distributed File System (HDFS) from your Node.js-Express application. Here's an example of reading a file from HDFS:

   ```javascript
   client.readFile('/example/file.txt', (err, data) => {
     if (err) {
       console.error(err);
       return;
     }
     console.log(data.toString());
   });
   ```

   Similarly, you can write files to HDFS, create directories, and perform other file system operations.

That's it! You now have a Hadoop cluster running in Docker containers, and you can integrate it with your Node.js-Express application using the `hadoop-js` library.