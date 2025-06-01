#!/bin/bash

# Настройки
KAFKA_BROKER="broker-1:19092"
TOPICS=("task-events" "another-topic")
RETENTION_MS=120000
KAFKA_TOPICS="/usr/bin/kafka-topics"

# Функция для создания топика
create_topic() {
  local topic_name=$1
  echo "Creating topic: $topic_name"

   $KAFKA_TOPICS \
    --bootstrap-server $KAFKA_BROKER \
    --create \
    --topic $topic_name \
    --config retention.ms=$RETENTION_MS \
    --config cleanup.policy=delete
}

# Ожидание доступности Kafka
echo "Waiting for Kafka to be ready..."
cub kafka-ready -b $KAFKA_BROKER 1 60

# Создание топиков
for topic in "${TOPICS[@]}"; do
  create_topic "$topic"
done

# Проверка
echo "Topic configuration:"
kafka-topics.sh \
  --bootstrap-server $KAFKA_BROKER \
  --describe \
  --topics-with-overrides