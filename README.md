# 🚀 Hadoop Cluster with Docker | Local Development  

Run a **Hadoop cluster** in a **Docker container**—no manual installation required!  

## 📌 Features  
✅ Single-node Hadoop setup (HDFS + YARN)  
✅ Based on official Hadoop Docker images  
✅ Persistent data storage via Docker volumes  
✅ Easy start/stop with `docker compose`  
✅ Pre-configured scripts for simplified setup  

---

## ⚡ Quick Start  

### 1️⃣ **Clone the Repository**  
```sh
    git clone https://github.com/raybags-dev/service_hadoop_local.git
    cd service_hadoop_local

- Ensure your .sh scripts have execution permissions:
```sh 
    chmod +x *.sh

- Start Hadoop Cluster
```sh
    ./start-hadoop.sh

- Stop Hadoop Cluster <stop persistent volume and remove containers>
```sh
    ./stop-hadoop.sh


### Manage HDFS Files

- Create a directory in HDFS:
```sh
hdfs dfs -mkdir -p /user/data

- Upload a file:
```sh
hdfs dfs -put localfile.txt /user/data/
