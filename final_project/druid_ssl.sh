#!/bin/bash

# Set passwords
KEYSTORE_PASSWORD="druid-keystore-password"
TRUSTSTORE_PASSWORD="druid-truststore-password"
CA_KEYSTORE_PASSWORD="server-ca-password"

# Create directories for SSL files
mkdir -p ./ssl/druid

# Generate the client key pair and create a keystore for Druid
keytool -genkeypair -alias druid-client -keyalg RSA -keystore ./ssl/druid/druid.keystore.jks -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD -dname "CN=kafka"

# Create a CSR for Druid
keytool -certreq -alias druid-client -keystore ./ssl/druid/druid.keystore.jks -file ./ssl/druid/druid-client.csr -storepass $KEYSTORE_PASSWORD

# Sign the CSR with the CA certificate
keytool -gencert -alias ca -keystore ./ssl/server.ca.jks -storepass $CA_KEYSTORE_PASSWORD -infile ./ssl/druid/druid-client.csr -outfile ./ssl/druid/druid-client-signed.crt -validity 365 -rfc

# Import the CA certificate into the Druid keystore
keytool -importcert -alias ca-cert -file ./ssl/server.ca.crt -keystore ./ssl/druid/druid.keystore.jks -storepass $KEYSTORE_PASSWORD -noprompt

# Import the signed client certificate into the Druid keystore
keytool -importcert -alias druid-client -file ./ssl/druid/druid-client-signed.crt -keystore ./ssl/druid/druid.keystore.jks -storepass $KEYSTORE_PASSWORD -noprompt

# Import the CA certificate into the Druid truststore
keytool -importcert -alias ca-cert -file ./ssl/server.ca.crt -keystore ./ssl/druid/druid.truststore.jks -storepass $TRUSTSTORE_PASSWORD -noprompt

echo "Druid keystore and truststore created successfully."
