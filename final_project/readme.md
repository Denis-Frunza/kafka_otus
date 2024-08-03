1. Data Pipeline

![Data Pipeline](./images/Data_Pipeline.png)


```
{
  "type": "kafka",
  "dataSchema": {
    // Your data schema configuration
  },
  "tuningConfig": {
    // Your tuning configuration
  },
  "ioConfig": {
    "topic": "ecommerce",
    "consumerProperties": {
      "bootstrap.servers": "localhost:9094",
      "security.protocol": "SSL",
      "ssl.truststore.location": "/home/denis/Documents/kafka/final_project/ssl/druid/druid.truststore.jks",
      "ssl.truststore.password": "druid-truststore-password",
      "ssl.keystore.location": "/home/denis/Documents/kafka/final_project/ssl/druid/druid.keystore.jks",
      "ssl.keystore.password": "druid-keystore-password",
      "ssl.key.password": "druid-keystore-password",
      "ssl.endpoint.identification.algorithm": "",
      "request.timeout.ms": "60000",
      "metadata.max.age.ms": "300000"
    }
  }
}
```