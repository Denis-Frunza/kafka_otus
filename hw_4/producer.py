from quixstreams import Application

app = Application(broker_address="localhost:9092", consumer_group="text-splitter-v1")

messages_topic = app.topic(name="messages", value_serializer="json")

messages = [
    {"chat_id": "id1", "text": "Lorem ipsum dolor sit amet"},
    {"chat_id": "id2", "text": "Consectetur adipiscing elit sed"},
    {"chat_id": "id1", "text": "Do eiusmod tempor incididunt ut labore et"},
    {"chat_id": "id3", "text": "Mollis nunc sed id semper"},
]


def main():
    with app.get_producer() as producer:
        for message in messages:
            kafka_msg = messages_topic.serialize(key=message["chat_id"], value=message)
            print(f'Produce event with key="{kafka_msg.key}" value="{kafka_msg.value}"')
            producer.produce(
                topic=messages_topic.name,
                key=kafka_msg.key,
                value=kafka_msg.value,
            )


if __name__ == "__main__":
    main()