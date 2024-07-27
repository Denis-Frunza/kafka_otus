import hashlib
import json
import random
import time
import pandas as pd
from dataclasses import asdict

import consts
from adapter.kafka import producer
from adapter.configs import TOPIC
from model import Purchase


brands = pd.read_csv("./data_collection/TV_DATASET_USA.csv")

brands["PRICING"] = brands["PRICING"].apply(
    lambda x: float(x.replace("$", "").replace(",", ""))
)

def delivery_report(err, msg):
    if err is not None:
        print(f"Message delivery failed: {err}")
    else:
        print(f"Message delivered to {msg.topic()} [{msg.partition()}]")


def get_pay_method(source, status_purchase, payment_modes, payment_store):
    if source == "Organic":
        payment = random.choice(payment_store)
        status = "COMPLETED"
        order_type = "STORE"
    else:
        payment = random.choice(payment_modes)
        status = random.choice(consts.PURCHASE_STATUS)
        order_type = "ONLINE"
    return payment, status, order_type


def get_coords(city):
    if city == "New York":
        coords = random.choice(consts.NY_coords)
    elif city == "Los Ángeles":
        coords = random.choice(consts.LA_coords)
    elif city == "Chicago":
        coords = random.choice(consts.CHI_coords)
    elif city == "Houston":
        coords = random.choice(consts.HOU_coords)
    elif city == "Philadelphia":
        coords = random.choice(consts.PHI_coords)
    return coords


for index, row in brands.iterrows():
    date = pd.to_datetime("today").strftime("%Y-%m-%d %H:%M:%S")
    product = row["PRODUCT_NAME"]
    pricing = row["PRICING"]
    commission_temp = random.choice(consts.COMMISSION)
    brand = row["BRAND"]
    screen = row["SCREEN_SIZE"]
    display = row["DISPLAY_TYPE"]
    resolution = row["DISPLAY_TYPE"]
    source_temp = random.choice(consts.sources)
    pay = get_pay_method(source_temp, consts.PURCHASE_STATUS, consts.PAYMENT_METHODS, consts.payment_store)
    city = random.choice(consts.cities)
    
    purchase = Purchase(
        purchase_id=str(
            hashlib.sha256(
                f"{index} {product} {pricing} {commission_temp} {date} {source_temp} {pay[1]}".encode("utf-8")
            ).hexdigest())[:10],
        product_name=product,
        pricing=str(int(pricing)),
        commission=str(commission_temp),
        revenue=str(round(pricing * commission_temp, 2)),
        payment_method=pay[0],
        status=pay[1],
        order_type=pay[2],
        city=city,
        location=str(get_coords(city)),
        latitud=str(get_coords(city)[0]),
        longitud=str(get_coords(city)[1]),
        source=source_temp,
        brand=brand,
        screen=str(screen),
        display=display,
        resolution=resolution,
        created_at=date,
    )
    
    record_value = json.dumps(asdict(purchase)).encode('utf-8')
    print(record_value)
    producer.produce(TOPIC, key="purchases", value=record_value, callback=delivery_report)
    producer.poll(0)

    time.sleep(random.choice([1, 1.5]))

producer.flush()
