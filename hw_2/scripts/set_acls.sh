#!/bin/bash

# Grant write permissions to User1
bash /bin/kafka-acls --bootstrap-server localhost:9092 --command-config /etc/kafka/admin.config \ 
--add --allow-principal User:user1 --operation WRITE --topic test-topic

# Grant read permissions to User2
bash /bin/kafka-acls --bootstrap-server localhost:9092 --command-config /etc/kafka/admin.config \
--add --allow-principal User:user2 --operation READ --topic test-topic

# Ensure User3 has no permissions (by not adding any ACLs for user3)
