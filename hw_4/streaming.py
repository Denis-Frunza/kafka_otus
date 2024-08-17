from quixstreams import Application

app = Application(
    broker_address="localhost:9092",
    consumer_group="text-splitter-v1",
    auto_offset_reset="earliest",
)

messages_topic = app.topic(name="events", value_deserializer="json")

sdf = app.dataframe(topic=messages_topic)

def calculate_total(message):
    return message

sdf = sdf.update(lambda message: print(f"Input: {message}"))
sdf = sdf.group_by("chat_id")
sdf = sdf.tumbling_window(duration_ms=300000).count().final()
sdf = sdf.apply(
    lambda value: {
        "count": value["value"], 
        "window": (value["start"], value["end"], ),
    }
)
sdf = sdf.update(lambda result: print(f"Output: {result}"))

if __name__ == "__main__":
    app.run(sdf)