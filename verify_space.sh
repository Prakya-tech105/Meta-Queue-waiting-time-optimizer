#!/bin/bash
# chmod +x verify_space.sh
SPACE_URL="https://Prakya-Queue-Waiting-Time-Optimizer-V3.hf.space"

echo "=== Checking root endpoint ==="
curl -s "$SPACE_URL/" | python3 -m json.tool

echo ""
echo "=== Checking /reset endpoint ==="
curl -s -X POST "$SPACE_URL/reset" \
    -H "Content-Type: application/json" \
    -d '{}' | python3 -m json.tool

echo ""
echo "If both return status: ok, your Space is live. Safe to resubmit."
