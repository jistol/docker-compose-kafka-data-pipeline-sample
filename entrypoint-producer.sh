#/bin/bash
KAFKA_PATH=$1
$KAFKA_PATH/bin/zookeeper-server-start.sh $KAFKA_PATH/config/zookeeper.properties > $KAFKA_PATH/logs/zookeeper.log &
$KAFKA_PATH/bin/kafka-server-start.sh $KAFKA_PATH/config/server.properties > $KAFKA_PATH/logs/kafka.log &

service filebeat start

/bin/bash
