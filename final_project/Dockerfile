FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY /app /app/
COPY /data_collection /app/data_collection 

CMD ["python", "etl.py"]
