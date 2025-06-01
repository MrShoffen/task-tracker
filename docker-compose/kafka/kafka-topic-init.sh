#!/bin/bash

KAFKA_BROKER="broker-1:19092"
TOPICS=("event.authentication.success" "event.comment.created" "event.comment.deleted" "event.credentials.email-update-attempt" "event.credentials.email-updated" "event.credentials.password-updated" "event.desk.created" "event.desk.deleted" "event.desk.updated" "event.registration.new" "event.registration.success" "event.sticker.created" "event.sticker.deleted" "event.task.created" "event.task.deleted" "event.task.updated" "event.workspace.created" "event.workspace.deleted" "event.workspace.updated")
PARTITIONS=12
REPLICATION_FACTOR=3
RETENTION_MS=120000
SEGMENT_MAX=104857600
SEGMENT_MS=8640000

KAFKA_TOPICS="/usr/bin/kafka-topics"
COMPLETION_FILE=/kafka-init-complete

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
    --config segment.bytes=$SEGMENT_MAX \
    --config segment.ms=$SEGMENT_MS \
    --config cleanup.policy=delete
done

echo "Verification:"
$KAFKA_TOPICS --bootstrap-server $KAFKA_BROKER --list

touch $COMPLETION_FILE
echo "Kafka topics initialized successfully"