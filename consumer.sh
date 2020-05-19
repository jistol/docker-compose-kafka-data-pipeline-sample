#/bin/bash
docker exec kafka_producer_1 /bin/bash -c "/usr/local/kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka_producer_1:9092 --max-messages 10 --topic producer-log --from-beginning"
