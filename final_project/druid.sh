#!/bin/bash

# Update packages
sudo apt update -y

# Install OpenJDK 8
sudo apt install openjdk-8-jdk -y

# Download Druid version 27.0.0
wget https://dlcdn.apache.org/druid/27.0.0/apache-druid-27.0.0-bin.tar.gz

# Extract the tar file
tar -xzf apache-druid-27.0.0-bin.tar.gz

# Change directory to Druid
cd apache-druid-27.0.0

# Set environment variables for JAVA and DRUID
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export DRUID_HOME=/home/ubuntu/apache-druid-27.0.0
PATH=$JAVA_HOME/bin:$DRUID_HOME/bin:$PATH