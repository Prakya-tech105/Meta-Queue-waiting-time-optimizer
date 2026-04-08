---
title: Queue Waiting Time Optimizer V3
emoji: 🐠
colorFrom: purple
colorTo: gray
sdk: gradio
sdk_version: 6.11.0
app_file: app.py
pinned: false
---

# Queue Waiting Time Optimizer V3

Queue Waiting Time Optimizer V3 is an AI decision-support system that learns when to open, hold, or close service counters to reduce queue length and waiting time under changing demand.

Built for hackathon impact, this project combines:
- A custom queue simulator and Gymnasium environment
- A rule-based baseline policy for reliability
- A DQN reinforcement learning agent for adaptive control
- An interactive Gradio dashboard for real-time scenario testing

## Why This Matters

Long queues cost revenue, customer trust, and staff efficiency. Most fixed staffing rules are too rigid for real-world demand spikes.

This project introduces adaptive queue control that can react to dynamic arrivals and balance service quality with operational cost.

## Problem Statement

Given a live queue system with variable incoming traffic, decide at every step whether to:
- Close a counter
- Do nothing
- Open a counter

Goal:
- Minimize average waiting time
- Minimize queue length
- Avoid unnecessary counter churn and overstaffing

## Solution Overview

The system models queue operations as a sequential decision-making problem:

- State: queue length, waiting time, open counters, incoming rate
- Action space: {close, hold, open}
- Reward: weighted combination of waiting time, queue length, number of open counters, and action smoothness

The app supports three policies:
- Baseline: deterministic rule-based thresholds
- Random: control sanity check
- DQN: learned policy (loads model if available, falls back safely otherwise)

## Key Features

- End-to-end RL pipeline from simulation to training and evaluation
- Scenario-based testing (`easy`, `medium`, `hard`)
- Seeded reproducibility support
- Rich visual analytics: queue, waiting time, open counters, cumulative reward
- Hugging Face Space-ready Gradio UI
- Safe fallback to baseline when model artifact is unavailable

## Tech Stack

- Python 3.10+
- Gymnasium
- Stable-Baselines3 (DQN)
- PyTorch
- Gradio
- Plotly + Pandas

## Project Structure

```text
queue-waiting-time-optimizer/
	app.py                        # Gradio app entrypoint
	inference.py                  # Structured inference entrypoint (START/STEP/END)
	configs/base.yaml             # Core reward/scenario config
	scripts/                      # Phase-wise demos, training, eval, plotting
	src/gradio_app.py             # UI and simulation workflow
	src/qwt_optimizer/            # Core package
		agents/rule_based.py
		envs/queue_simulator.py
		envs/queue_gym_env.py
		utils/seeding.py
	tests/                        # Unit tests for simulator/env/reproducibility/agent
```

## Quick Start (Local)

```bash
cd queue-waiting-time-optimizer
python -m pip install -r requirements.txt
python -m pip install -e .
python app.py
```

Open the URL printed in terminal (for example: `http://127.0.0.1:7860`).

## Run Training and Evaluation

```bash
cd queue-waiting-time-optimizer

# Train DQN
python scripts/phase5_train_dqn.py --scenario medium --timesteps 20000 --seed 42

# Evaluate baseline vs random vs dqn
python scripts/phase6_evaluate_agents.py --scenario medium --episodes 10 --max-steps 300

# Plot traces and summary charts
python scripts/phase7_plot_results.py
```

## Demo Flow (Hackathon Pitch)

1. Start on `medium` scenario with baseline policy.
2. Show queue/wait trends and cumulative reward.
3. Switch to DQN policy with saved model path.
4. Compare how policy behavior changes under `hard` scenario.
5. Highlight reduced congestion and adaptive counter management.

## Reproducibility

- Global seeding is applied for deterministic behavior where possible.
- Tests cover simulator behavior, Gym environment API, rule-based policy, and reproducibility checks.

## Deployment

This repository is structured for Hugging Face Spaces with Gradio runtime.

Space URL:
- https://huggingface.co/spaces/Prakya/Queue-Waiting-Time-Optimizer-V3

## Future Improvements

- Multi-objective optimization with dynamic reward balancing
- Traffic forecasting integration for proactive staffing
- Multi-queue/multi-site coordination
- Human-in-the-loop controls for operations teams

## Team

Queue Waiting Time Optimizer Team

## License

For hackathon/demo use. Add your preferred OSS license before production release.
