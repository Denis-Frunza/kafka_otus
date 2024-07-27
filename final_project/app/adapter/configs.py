TOPIC = 'ecommerce' 

kafka_conf = {
    'bootstrap.servers': 'kafka:9093',
    'client.id': 'e-commerce',
    'security.protocol': 'SSL',
    'acks': 'all',
    'retries': 5,
    'enable.idempotence': True,
    'delivery.timeout.ms': 3000,
    'request.timeout.ms': 5000,
    'ssl.ca.location': '/etc/kafka/secrets/server.ca.crt',
    'ssl.certificate.location': '/etc/kafka/secrets/client-cert.pem',
    'ssl.key.location': '/etc/kafka/secrets/client-key.pem',
    'ssl.key.password': 'client-ks-password',
    'ssl.endpoint.identification.algorithm': 'none'
}