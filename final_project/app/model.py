from dataclasses import dataclass


@dataclass
class Purchase:
    purchase_id: str
    product_name: str
    pricing: str
    commission: str
    revenue: str
    payment_method: str
    status: str
    order_type: str
    city: str
    location: str
    latitud: str
    longitud: str
    source: str
    brand: str
    screen: str
    display: str
    resolution: str
    created_at: str
