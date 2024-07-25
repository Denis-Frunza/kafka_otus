from confluent_kafka import Producer

from adapter import configs


producer = Producer(configs.kafka_conf)
1