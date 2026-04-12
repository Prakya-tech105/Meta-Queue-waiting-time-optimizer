#!/bin/bash
SPACE_URL="https://Prakya-Queue-Waiting-Time-Optimizer-V3.hf.space"

echo "=== Pinging root ==="
curl -s "$SPACE_URL/" | python3 -m json.tool

echo ""
echo "=== Running reset to confirm Space responds ==="
curl -s -X POST "$SPACE_URL/reset" \
    -H "Content-Type: application/json" \
    -d '{"session_id": "test-123"}' | python3 -m json.tool

echo ""
echo "=== Checking Space build logs on HF ==="
echo "Manually visit this URL and confirm build is SUCCESS not CACHED:"
echo "https://huggingface.co/spaces/Prakya/Queue-Waiting-Time-Optimizer-V3/logs"
