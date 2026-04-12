#!/bin/bash
# chmod +x run_and_verify.sh

echo "=== Running inference.py locally ==="
python inference.py 2>&1 | tee /tmp/inference_output.txt

echo ""
echo "=== Checking for required [START] lines ==="
grep -c "^\[START\]" /tmp/inference_output.txt

echo "=== Checking for required [END] lines with score ==="
grep "^\[END\]" /tmp/inference_output.txt | grep "score"

echo "=== Checking scores are not 0.0 or 1.0 exactly ==="
if grep "^\[END\]" /tmp/inference_output.txt | grep -E '"score": (0\.0|1\.0)'; then
    echo "FAIL: Found exact 0.0 or 1.0 score — fix before submitting"
    exit 1
else
    echo "PASS: All scores are in strict open interval (0, 1)"
fi

echo ""
echo "=== All checks passed. Safe to push and resubmit. ==="
