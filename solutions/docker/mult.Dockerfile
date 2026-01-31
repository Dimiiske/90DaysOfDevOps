FROM python:3.11.14-alpine3.23 AS base

WORKDIR /app

FROM base AS installer 

RUN pip install flask

FROM installer AS app

COPY app.py .

CMD ["python3", "/app/app.py"]
