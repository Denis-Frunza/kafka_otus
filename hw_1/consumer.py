import six
import sys
if sys.version_info >= (3, 12, 1):
    sys.modules['kafka.vendor.six.moves'] = six.moves

from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'test',
    bootstrap_servers=['localhost:9092'],
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    group_id='my-group',
    value_deserializer=lambda x: x.decode('utf-8')
)

print("Connected to Kafka broker, subscribed to 'test' topic.")
print("Waiting for messages...")

try:
    print("Consuming messages from 'test' topic:")
    for message in consumer:
        print(f"Received message: {message.value}")
except KeyboardInterrupt:
    print("Consumer interrupted. Closing...")
finally:
    consumer.close()
    print("Consumer closed.")
