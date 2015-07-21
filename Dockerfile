# Kafka and Zookeeper

FROM cogniteev/oracle-java:java7

ENV DEBIAN_FRONTEND noninteractive

# Install Kafka, Zookeeper and other needed things
RUN apt-get update && \
    apt-get install -y zookeeper wget supervisor dnsutils vim tree && \
    rm -rf /var/lib/apt/lists/*

RUN \
    wget -q http://mirror.sdunix.com/apache/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz -O /tmp/kafka_2.10.0-0.8.2.1.tgz && \
    tar xfz /tmp/kafka_2.10.0-0.8.2.1.tgz -C /opt && \
    rm /tmp/kafka_2.10.0-0.8.2.1.tgz

ENV KAFKA_HOME /opt/kafka_2.10-0.8.2.1
ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
ADD supervisor/kafka.conf /etc/supervisor/conf.d/kafka.conf
ADD supervisor/zookeeper.conf /etc/supervisor/conf.d/zookeeper.conf

# Kafka config
ADD config/server.properties $KAFKA_HOME/config/server.properties

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

CMD ["supervisord", "-n"]