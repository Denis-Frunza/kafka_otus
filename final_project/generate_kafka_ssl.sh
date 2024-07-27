#!/bin/bash

# Configuration
CA_KEYSTORE="server.ca.jks"
CA_CERT="server.ca.crt"
CA_ALIAS="ca"
CA_PASSWORD="server-ca-password"

SERVER_KEYSTORE="server.ks.jks"
SERVER_CERT="server.crt"
SERVER_CSR="server.csr"
SERVER_ALIAS="server"
SERVER_PASSWORD="server-ks-password"
SERVER_SAN="DNS:kafka"

TRUSTSTORE="server.ts.jks"
TRUSTSTORE_PASSWORD="server-ts-password"

CLIENT_KEYSTORE="client.ks.jks"
CLIENT_CERT="client.crt"
CLIENT_CSR="client.csr"
CLIENT_ALIAS="client"
CLIENT_PASSWORD="client-ks-password"
CLIENT_SAN="DNS:etl"

mkdir -p ssl
cd ssl

# Create CA keystore and export CA certificate
echo "Creating CA keystore and exporting CA certificate..."
keytool -genkeypair -alias $CA_ALIAS -keyalg RSA -keysize 2048 -keystore $CA_KEYSTORE -storetype JKS -storepass $CA_PASSWORD -keypass $CA_PASSWORD -dname "CN=Kafka-CA" -ext bc=ca:true -validity 365
keytool -export -file $CA_CERT -keystore $CA_KEYSTORE -storetype JKS -storepass $CA_PASSWORD -alias $CA_ALIAS -rfc

# Create server keystore and generate a CSR
echo "Creating server keystore and generating a CSR..."
keytool -genkeypair -alias $SERVER_ALIAS -keyalg RSA -keysize 2048 -keystore $SERVER_KEYSTORE -storetype JKS -storepass $SERVER_PASSWORD -keypass $SERVER_PASSWORD -dname "CN=kafka" -validity 365
keytool -certreq -file $SERVER_CSR -keystore $SERVER_KEYSTORE -storetype JKS -storepass $SERVER_PASSWORD -keypass $SERVER_PASSWORD -alias $SERVER_ALIAS

# Sign the server certificate with the CA
echo "Signing the server certificate with the CA..."
keytool -gencert -infile $SERVER_CSR -outfile $SERVER_CERT -keystore $CA_KEYSTORE -storetype JKS -storepass $CA_PASSWORD -alias $CA_ALIAS -ext SAN=$SERVER_SAN -validity 365

# Combine the server certificate and CA certificate into a chain
echo "Combining server and CA certificates into a chain..."
cat $SERVER_CERT $CA_CERT > serverchain.crt

# Import the certificate chain into the server keystore
echo "Importing the certificate chain into the server keystore..."
keytool -importcert -file serverchain.crt -keystore $SERVER_KEYSTORE -storetype JKS -storepass $SERVER_PASSWORD -keypass $SERVER_PASSWORD -alias $SERVER_ALIAS -noprompt

# Create truststore and import the CA certificate
echo "Creating truststore and importing the CA certificate..."
keytool -importcert -file $CA_CERT -keystore $TRUSTSTORE -storetype JKS -storepass $TRUSTSTORE_PASSWORD -alias $SERVER_ALIAS -noprompt

# Create client keystore and generate a CSR
echo "Creating client keystore and generating a CSR..."
keytool -genkeypair -alias $CLIENT_ALIAS -keyalg RSA -keysize 2048 -keystore $CLIENT_KEYSTORE -storetype JKS -storepass $CLIENT_PASSWORD -keypass $CLIENT_PASSWORD -dname "CN=etl_app,C=GB" -validity 365
keytool -certreq -file $CLIENT_CSR -keystore $CLIENT_KEYSTORE -storetype JKS -storepass $CLIENT_PASSWORD -keypass $CLIENT_PASSWORD -alias $CLIENT_ALIAS

# Sign the client certificate with the CA
echo "Signing the client certificate with the CA..."
keytool -gencert -infile $CLIENT_CSR -outfile $CLIENT_CERT -keystore $CA_KEYSTORE -storetype JKS -storepass $CA_PASSWORD -alias $CA_ALIAS -ext SAN=$CLIENT_SAN -validity 365

# Combine the client certificate and CA certificate into a chain
echo "Combining client and CA certificates into a chain..."
cat $CLIENT_CERT $CA_CERT > clientchain.crt

# Import the certificate chain into the client keystore
echo "Importing the certificate chain into the client keystore..."
keytool -importcert -file clientchain.crt -keystore $CLIENT_KEYSTORE -storetype JKS -storepass $CLIENT_PASSWORD -keypass $CLIENT_PASSWORD -alias $CLIENT_ALIAS -noprompt

# Import client CA certificate into the server truststore
echo "Importing client CA certificate into the server truststore..."
keytool -import -file $CA_CERT -keystore $TRUSTSTORE -alias client -storetype JKS -storepass $TRUSTSTORE_PASSWORD -noprompt

# Save passwords to files
echo "Saving passwords to files..."
echo $SERVER_PASSWORD > keystore-creds
echo $SERVER_PASSWORD > key-creds
echo $TRUSTSTORE_PASSWORD > truststore-creds

# Convert client JKS keystores to PKCS12 format
echo "Converting client keystore to PKCS12 format..."
keytool -importkeystore -srckeystore $CLIENT_KEYSTORE -destkeystore client.ks.p12 -deststoretype PKCS12 -srcstorepass $CLIENT_PASSWORD -deststorepass $CLIENT_PASSWORD -srcalias $CLIENT_ALIAS -destalias $CLIENT_ALIAS -srckeypass $CLIENT_PASSWORD -destkeypass $CLIENT_PASSWORD

# Extract PEM files from PKCS12 keystores
echo "Extracting PEM files from PKCS12 keystore..."
openssl pkcs12 -in client.ks.p12 -nokeys -out client-cert.pem -passin pass:$CLIENT_PASSWORD
openssl pkcs12 -in client.ks.p12 -nocerts -nodes -out client-key.pem -passin pass:$CLIENT_PASSWORD

echo "All operations completed successfully."
