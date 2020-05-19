#/bin/bash
docker exec -it kafka_producer_1 /bin/bash -c "/usr/local/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic producer-log"
