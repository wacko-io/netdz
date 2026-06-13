#!/bin/bash

ROUNDS=${1:-3}
DELAY=${2:-2}
BASE_URL=${3:-"http://localhost"}

echo "=== Traffic Generator ==="
echo "Rounds: $ROUNDS | Delay: ${DELAY}s | URL: $BASE_URL"
echo ""

# Get auth token
echo -e "\e[33m[1/4] Getting auth token...\e[0m"
TOKEN=$(curl -s -X POST "$BASE_URL/v1/token" \
    -H "Content-Type: application/json" \
    -d '{"login":"bob","password":"qwe123"}')

if [ -z "$TOKEN" ]; then
    echo -e "\e[31m  FAILED to get token\e[0m"
    exit 1
fi
echo -e "\e[32m  Token received\e[0m"

for ((round=1; round<=ROUNDS; round++)); do
    echo ""
    echo -e "\e[36m--- Round $round / $ROUNDS ---\e[0m"

    # Security: /v1/token + /v1/user
    echo -e "\e[33m[security] Sending requests...\e[0m"
    for i in {1..5}; do
        curl -s -o /dev/null -X POST "$BASE_URL/v1/token" \
            -H "Content-Type: application/json" \
            -d '{"login":"bob","password":"qwe123"}'
    done
    for i in {1..3}; do
        curl -s -o /dev/null "$BASE_URL/v1/user" \
            -H "Authorization: Bearer $TOKEN" || true
    done
    echo -e "\e[32m  8 requests sent\e[0m"

    # Uploader: /v1/upload
    echo -e "\e[33m[uploader] Sending requests...\e[0m"
    for i in {1..5}; do
        curl -s -o /dev/null -X POST "$BASE_URL/v1/upload" \
            -H "Authorization: Bearer $TOKEN" \
            --data-binary $'\x89PNG\r\n\x1a\n' || true
    done
    echo -e "\e[32m  5 requests sent\e[0m"

    # Storage: /v1/user/*
    echo -e "\e[33m[storage]  Sending requests...\e[0m"
    for file in photo1.jpg photo2.png avatar.jpg img_001.webp test.gif; do
        curl -s -o /dev/null "$BASE_URL/v1/user/$file" \
            -H "Authorization: Bearer $TOKEN" || true
    done
    echo -e "\e[32m  5 requests sent\e[0m"

    if [ "$round" -lt "$ROUNDS" ]; then
        echo -e "\e[90mWaiting ${DELAY}s...\e[0m"
        sleep "$DELAY"
    fi
done

echo ""
echo -e "\e[36m=== Done! Total: $((ROUNDS * 18)) requests ===\e[0m"
echo -e "\e[90mWait ~30s for Prometheus to scrape, then check Grafana dashboard.\e[0m"
