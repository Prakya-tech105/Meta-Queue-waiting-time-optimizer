#!/bin/bash
set -e

echo "=== Verifying inference.py output BEFORE pushing ==="
python inference.py 2>&1 | tee /tmp/check.txt

START_COUNT=$(grep -c "^\[START\]" /tmp/check.txt)
END_COUNT=$(grep -c "^\[END\]" /tmp/check.txt)
SCORE_LINES=$(grep "^\[END\]" /tmp/check.txt | grep "score")

echo "START lines found: $START_COUNT"
echo "END lines found: $END_COUNT"
echo "Score lines: $SCORE_LINES"

if [ "$END_COUNT" -lt 3 ]; then
    echo "FAIL: Less than 3 [END] lines found. Fix inference.py first."
    exit 1
fi

if grep "^\[END\]" /tmp/check.txt | grep -E '"score": (0\.0|1\.0)'; then
    echo "FAIL: Exact 0.0 or 1.0 score found."
    exit 1
fi

echo "=== Local check PASSED ==="

echo "=== Removing cached git objects ==="
git gc --prune=now

echo "=== Force adding all files ==="
git add -A
git status

echo "=== Committing with timestamp to force new hash ==="
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
git commit -m "force-redeploy: cache bust $TIMESTAMP" --allow-empty

echo "=== Pushing to GitHub ==="
git push origin main --force

echo "=== Pushing to HF Space with force ==="
git push space main --force

echo ""
echo "=== DONE. Now wait 3-4 minutes for Space to rebuild ==="
echo "=== Then run: bash verify_space.sh ==="
echo "=== Then resubmit on the dashboard ==="
