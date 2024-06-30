## Execute the ACL Script:
chmod +x set_acls.sh
docker exec -it kafka /usr/local/bin/set_acls.sh

## Test Producer for user1
docker exec -it kafka kafka-console-producer --broker-list localhost:9092 --topic test-topic --producer.config /etc/kafka/producer_user1.properties

## Test Producer for user2
docker exec -it kafka kafka-console-producer --broker-list localhost:9092 --topic test-topic --producer.config /etc/kafka/producer_user2.properties

## Test Producer for user3
docker exec -it kafka kafka-console-producer --broker-list localhost:9092 --topic test-topic --producer.config /etc/kafka/producer_user3.properties

## Test Consumer for user1
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic test-topic --from-beginning --consumer.config /etc/kafka/consumer_user1.properties

## Test Consumer for user2
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic test-topic --from-beginning --consumer.config /etc/kafka/consumer_user2.properties

## Test Consumer for user3
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic test-topic --from-beginning --consumer.config /etc/kafka/consumer_user3.properties



## kafka-topics --list user1
docker exec -it kafka kafka-topics --list --bootstrap-server localhost:9092 --command-config /etc/kafka/producer_user1.properties

## kafka-topics --list user2
docker exec -it kafka kafka-topics --list --bootstrap-server localhost:9092 --command-config /etc/kafka/producer_user2.properties

## kafka-topics --list user3
docker exec -it kafka kafka-topics --list --bootstrap-server localhost:9092 --command-config /etc/kafka/producer_user3.properties
