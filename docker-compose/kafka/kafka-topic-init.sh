#!/bin/bash

# Настройки
KAFKA_BROKER="broker-1:19092"  # Адрес одного из ваших брокеров
TOPICS=("task-events" "another-topic")  # Список топиков для создания
PARTITIONS=12                     # Количество партиций (как в вашем docker-compose)
REPLICATION_FACTOR=3              # Фактор репликации (как в вашем docker-compose)
RETENTION_MS=120000               # 2 минуты в миллисекундах

# Функция для создания топика
create_topic() {
  local topic_name=$1
  echo "Создаю топик: $topic_name"

  docker exec -it broker-1-task kafka-topics.sh \
    --bootstrap-server $KAFKA_BROKER \
    --create \
    --topic $topic_name \
    --config retention.ms=$RETENTION_MS \
    --config cleanup.policy=delete
}

# Основной цикл
for topic in "${TOPICS[@]}"; do
  create_topic "$topic"
done

echo "Все топики успешно созданы с настройками:"
echo "Partitions: $PARTITIONS, Replication: $REPLICATION_FACTOR, Retention: $RETENTION_MS ms"

# Проверка созданных топиков
echo "Проверка созданных топиков:"
docker exec -it broker-1-task kafka-topics.sh \
  --bootstrap-server $KAFKA_BROKER \
  --describe \
  --topics-with-overrides