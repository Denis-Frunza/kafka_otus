FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN apt-get update && apt-get install -y ca-certificates
RUN pip install --no-cache-dir -r requirements.txt

COPY /app /app/
COPY ./ssl /etc/kafka/secrets
COPY /data_collection /app/data_collection 

CMD ["python", "etl.py"]
