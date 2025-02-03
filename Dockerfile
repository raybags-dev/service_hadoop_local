FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

RUN mkdir -p /hadoop/dfs/name /hadoop/dfs/data

COPY start-hadoop.sh /start-hadoop.sh
RUN chmod +x /start-hadoop.sh

CMD ["/start-hadoop.sh"]