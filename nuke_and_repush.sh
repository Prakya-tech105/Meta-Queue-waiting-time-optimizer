#!/bin/bash
set -e

HF_SPACE="https://huggingface.co/spaces/Prakya/Queue-Waiting-Time-Optimizer-V3"

echo "=== Removing old space remote ==="
git remote remove space 2>/dev/null || true

echo "=== Re-adding space remote ==="
git remote add space $HF_SPACE

echo "=== Verifying remotes ==="
git remote -v

echo "=== Creating cache bust file ==="
echo "bust_$(date +%Y%m%d_%H%M%S)" > .huggingface_cache_bust
git add .huggingface_cache_bust
git commit -m "cache bust: force HF Space rebuild $(date)" --allow-empty

echo "=== Force pushing to HF Space ==="
git push space main --force

echo ""
echo "=== Done. Visit HF Space logs to confirm rebuild started ==="
echo "https://huggingface.co/spaces/Prakya/Queue-Waiting-Time-Optimizer-V3/logs"
