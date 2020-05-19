#/bin/bash
docker-compose -f ./kafka-compose.yml down
docker volume rm kafka_broker kafka_es kafka_nifi kafka_producer
