#!/bin/bash

# Настройки
KAFKA_BROKER="broker-1:19092"
TOPICS=("task-events" "another-topic")
PARTITIONS=12
REPLICATION_FACTOR=3
RETENTION_MS=120000

# Полные пути к утилитам в Confluent образе
KAFKA_TOPICS="/usr/bin/kafka-topics"


# Создание топиков
for topic in "${TOPICS[@]}"; do
  echo "Creating topic: $topic"
  $KAFKA_TOPICS --bootstrap-server $KAFKA_BROKER \
    --create \
    --if-not-exists \
    --topic $topic \
    --partitions $PARTITIONS \
    --replication-factor $REPLICATION_FACTOR \
    --config retention.ms=$RETENTION_MS \
    --config cleanup.policy=delete
done

echo "Verification:"
$KAFKA_TOPICS --bootstrap-server $KAFKA_BROKER --list