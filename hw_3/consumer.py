from confluent_kafka import Consumer, KafkaException, KafkaError

KAFKA_BROKER = 'localhost:9092'


conf = {
    'bootstrap.servers': KAFKA_BROKER,
    'auto.offset.reset': 'earliest',
    'group.id': 'my_consumer_group',
    'isolation.level': 'read_committed',
}

consumer = Consumer(conf)

consumer.subscribe(['topic1', 'topic2'])


def consume_messages():
    try:
        while True:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue

            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    print(f"End of partition reached {msg.partition()}")
                elif msg.error():
                    raise KafkaException(msg.error())
            else:
                print(f"Received message from {msg.topic()} [partition {msg.partition()}]: {msg.value().decode('utf-8')}, key: {msg.key().decode('utf-8')}")

    except KeyboardInterrupt:
        pass
    finally:
        consumer.close()

if __name__ == '__main__':
    consume_messages()