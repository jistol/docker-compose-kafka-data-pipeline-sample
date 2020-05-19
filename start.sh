#/bin/bash
docker-compose -f ./kafka-compose.yml up -d --build --force-recreate

DELAY_TIME=$(seq 0 7)
for i in $DELAY_TIME
do
    echo -n "."
    sleep 1
done

echo " "

docker exec kafka_producer_1 /bin/bash -c "/usr/local/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --topic producer-log --partitions 1 --replication-factor 1 --create"
docker exec kafka_producer_1 /bin/bash -c "/usr/local/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --topic preparing-log --partitions 1 --replication-factor 1 --create"
docker exec kafka_producer_1 /bin/bash -c "/usr/local/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --topic removed-log --partitions 1 --replication-factor 1 --create"
docker exec kafka_producer_1 /bin/bash -c "/usr/local/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --topic etc-log --partitions 1 --replication-factor 1 --create"

sleep 1

docker exec -it kafka_producer_1 /bin/bash -c "/usr/local/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic producer-log"
