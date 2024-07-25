TOPIC = 'ecommerce' 

kafka_conf = {
    'bootstrap.servers': 'kafka:29092',
    'client.id': 'e-commerce',
    'security.protocol': 'SASL_PLAINTEXT',
    'sasl.mechanisms': 'PLAIN',
    'sasl.username': 'denis_frunza',
    'sasl.password': 'password1',
    'acks': 'all',
    'retries': 5,
    'enable.idempotence': True,
    'delivery.timeout.ms': 3000,
    'request.timeout.ms': 5000,
# 'security.protocol': 'SASL_SSL',
# 'sasl.mechanisms': 'PLAIN',
# 'sasl.username': '<API_KEY_HERE>',
# 'sasl.password': '<API_SECRET_HERE>'
}