FROM python:3.12-slim AS builder

WORKDIR /app

RUN python -m venv /app/venv

ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt .

RUN --mount=type=cache,target=~/.cache/pip pip install -r requirements.txt

FROM python:3.12-slim AS worker

WORKDIR /app

RUN addgroup --system python && \
    adduser --ingroup python python && \
    apt-get update && apt-get install -y wget && \
    mkdir -p /home/python/.mysql && \
    wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" -O /home/python/.mysql/root.crt && \
    chown -R python:python /home/python/.mysql && chown python:python /app

USER python

COPY --chown=python:python --from=builder /app/venv /app/venv

COPY --chown=python:python . .

ENV PATH="/app/venv/bin:$PATH"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"] 