#!/bin/bash
# chmod +x redeploy.sh
echo "=== Step 1: Staging all changes ==="
git add -A

echo "=== Step 2: Committing ==="
git commit -m "fix: sync latest inference.py to HF Space"

echo "=== Step 3: Pushing to GitHub ==="
git push origin main

echo "=== Step 4: Push to Hugging Face Space ==="
git push space main

echo "=== Done. Wait for HF Space to show Running before resubmitting ==="
