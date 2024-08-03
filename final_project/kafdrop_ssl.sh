#!/bin/bash

# Set the passwords
KEYSTORE_PASSWORD="client-keystore-password"
TRUSTSTORE_PASSWORD="client-truststore-password"
CA_KEYSTORE_PASSWORD="server-ca-password"

# Create directories for SSL files
mkdir -p ./ssl/kafdrop

# Generate the client key pair and create a keystore
keytool -genkeypair -alias kafka-client -keyalg RSA -keystore ./ssl/kafdrop/kafka.client.keystore.jks -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD -dname "CN=kafka"

# Create a CSR for the client
keytool -certreq -alias kafka-client -keystore ./ssl/kafdrop/kafka.client.keystore.jks -file ./ssl/kafdrop/kafka-client.csr -storepass $KEYSTORE_PASSWORD

# Sign the CSR with the CA certificate
keytool -gencert -alias ca -keystore ./ssl/server.ca.jks -storepass $CA_KEYSTORE_PASSWORD -infile ./ssl/kafdrop/kafka-client.csr -outfile ./ssl/kafdrop/kafka-client-signed.crt -validity 365 -rfc

# Import the CA certificate into the client keystore
keytool -importcert -alias ca-cert -file ./ssl/server.ca.crt -keystore ./ssl/kafdrop/kafka.client.keystore.jks -storepass $KEYSTORE_PASSWORD -noprompt

# Import the signed client certificate into the client keystore
keytool -importcert -alias kafka-client -file ./ssl/kafdrop/kafka-client-signed.crt -keystore ./ssl/kafdrop/kafka.client.keystore.jks -storepass $KEYSTORE_PASSWORD -noprompt

# Import the CA certificate into the client's truststore
keytool -importcert -alias ca-cert -file ./ssl/server.ca.crt -keystore ./ssl/kafdrop/kafka.client.truststore.jks -storepass $TRUSTSTORE_PASSWORD -noprompt

# Create kafka.properties file
cat <<EOL > ./ssl/kafdrop/kafka.properties
security.protocol=SSL
ssl.truststore.location=/etc/kafka/secrets/kafka.client.truststore.jks
ssl.keystore.location=/etc/kafka/secrets/kafka.client.keystore.jks
ssl.truststore.password=$TRUSTSTORE_PASSWORD
ssl.keystore.password=$KEYSTORE_PASSWORD
ssl.key.password=$KEYSTORE_PASSWORD
EOL

# Export base64 encoded files for environment variables
export KAFKA_PROPERTIES_BASE64=$(cat ./ssl/kafdrop/kafka.properties | base64)
export KAFKA_TRUSTSTORE_BASE64=$(cat ./ssl/kafdrop/kafka.client.truststore.jks | base64)
export KAFKA_KEYSTORE_BASE64=$(cat ./ssl/kafdrop/kafka.client.keystore.jks | base64)

# # Run the kafdrop container
# docker run -d --rm --network=kafka-network -p 9000:9000 \
#   -e KAFKA_BROKERCONNECT=kafka:9093 \
#   -e KAFKA_PROPERTIES="$KAFKA_PROPERTIES_BASE64" \
#   -e KAFKA_TRUSTSTORE="$KAFKA_TRUSTSTORE_BASE64" \
#   -e KAFKA_KEYSTORE="$KAFKA_KEYSTORE_BASE64" \
#   -v $(pwd)/ssl/kafdrop:/etc/kafka/secrets \
#   obsidiandynamics/kafdrop

# echo "Kafdrop is running on port 9000"
