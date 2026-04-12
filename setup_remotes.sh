#!/bin/bash
# chmod +x setup_remotes.sh
echo "Adding HF Space as git remote..."
git remote remove space 2>/dev/null || true
git remote add space https://huggingface.co/spaces/Prakya/Queue-Waiting-Time-Optimizer-V3
echo "Current remotes:"
git remote -v
