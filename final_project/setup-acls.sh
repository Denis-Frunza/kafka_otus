#!/bin/bash

sleep 20

kafka-acls --authorizer-properties zookeeper.connect=zookeeper:2182 --add --allow-principal User:denis_frunza --operation Write --topic ecommerce