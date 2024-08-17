# import six
# import sys
# if sys.version_info >= (3, 12, 1):
#     sys.modules['kafka.vendor.six.moves'] = six.moves

# from kafka import KafkaProducer
from confluent_kafka import Producer, KafkaException
import json


KAFKA_BROKER = 'localhost:9092'

conf = {
    'bootstrap.servers': KAFKA_BROKER,
    'transactional.id': 'otus',
}

# producer = Producer(
#     bootstrap_servers=[KAFKA_BROKER,],
#     value_serializer=lambda v: json.dumps(v).encode('utf-8')
# )

producer = Producer(conf)

producer.init_transactions()

producer.begin_transaction()
for i in range(5):
    producer.produce('topic1', key=str(i), value=f'[Transaction]message {i}',)
    producer.produce('topic2', key=str(i), value=f'[Transaction]message {i}')
    print(f'Sent: {i}')

producer.flush()
producer.commit_transaction()

print("Transaction committed successfully")


producer.begin_transaction()
for i in range(2):
    producer.produce('topic1', key=str(i), value=f'[Transaction Failed]message {i}',)
    producer.produce('topic2', key=str(i), value=f'[Transaction Failed]message {i}')
    print(f'Sent: {i}')

producer.flush()
producer.abort_transaction()

print("Second transaction aborted successfully")


producer.flush()