#!/bin/bash

# Configuration
KEYSTORE="kafka-server-keystore.jks"
TRUSTSTORE="kafka-server-truststore.jks"
SRVPASS="yourpassword"
DAYS_VALID=365
DNAME="CN=localhost"
CA_DNAME="CN=RootCA"

# Create directories if they don't exist
mkdir -p ssl

# Generate Kafka server keypair and keystore
keytool -genkeypair -alias kafka-server -keyalg RSA -keysize 2048 -keystore ssl/$KEYSTORE -storepass $SRVPASS -validity $DAYS_VALID -dname "$DNAME" -storetype JKS
echo "Kafka server keystore generated as ssl/$KEYSTORE."

# Generate a Certificate Signing Request (CSR) from the keystore
keytool -certreq -alias kafka-server -keystore ssl/$KEYSTORE -file ssl/kafka-server.csr -storepass $SRVPASS
echo "Certificate Signing Request (CSR) generated as ssl/kafka-server.csr."

# Generate root CA keypair and keystore
keytool -genkeypair -alias CARoot -keyalg RSA -keysize 2048 -keystore ssl/root-ca-keystore.jks -storepass $SRVPASS -validity $DAYS_VALID -dname "$CA_DNAME" -storetype JKS
echo "Root CA keystore generated as ssl/root-ca-keystore.jks."

# Export the root CA certificate
keytool -exportcert -alias CARoot -keystore ssl/root-ca-keystore.jks -storepass $SRVPASS -file ssl/root-ca-cert.crt
echo "Root CA certificate exported as ssl/root-ca-cert.crt."

# Sign the Kafka server certificate with the root CA
keytool -gencert -alias CARoot -keystore ssl/root-ca-keystore.jks -infile ssl/kafka-server.csr -outfile ssl/kafka-server-cert.crt -storepass $SRVPASS -validity $DAYS_VALID
echo "Kafka server certificate signed and generated as ssl/kafka-server-cert.crt."

# Import the root CA certificate into the Kafka server keystore
keytool -importcert -alias CARoot -file ssl/root-ca-cert.crt -keystore ssl/$KEYSTORE -storepass $SRVPASS -noprompt
echo "Root CA certificate imported into Kafka server keystore."

# Import the signed Kafka server certificate into the keystore
keytool -importcert -alias kafka-server -file ssl/kafka-server-cert.crt -keystore ssl/$KEYSTORE -storepass $SRVPASS -noprompt
echo "Signed Kafka server certificate imported into Kafka server keystore."

# Create the truststore and import the root CA certificate
keytool -importcert -alias CARoot -file ssl/root-ca-cert.crt -keystore ssl/$TRUSTSTORE -storepass $SRVPASS -storetype JKS -noprompt
echo "Truststore created as ssl/$TRUSTSTORE and Root CA certificate imported."

# Verify keystore and truststore contents
echo "Verifying keystore contents..."
keytool -list -keystore ssl/$KEYSTORE -storepass $SRVPASS -storetype JKS

echo "Verifying truststore contents..."
keytool -list -keystore ssl/$TRUSTSTORE -storepass $SRVPASS -storetype JKS


echo "yourpassword" > ssl/keystore-creds
echo "yourpassword" > ssl/key-creds
echo "yourpassword" > ssl/truststore-creds

