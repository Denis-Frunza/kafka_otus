import six
import sys
if sys.version_info >= (3, 12, 1):
    sys.modules['kafka.vendor.six.moves'] = six.moves

from kafka import KafkaProducer
import json


KAFKA_BROKER = '0.0.0.0:9092'

producer = KafkaProducer(
    bootstrap_servers=[KAFKA_BROKER,],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')  # Serialize messages as JSON
)

TOPIC = 'test'

for i in range(10):
    message = {'key': i, 'value': f'message {i}'}
    producer.send(TOPIC, value=message)
    print(f'Sent: {message}')

producer.flush()
producer.close()
