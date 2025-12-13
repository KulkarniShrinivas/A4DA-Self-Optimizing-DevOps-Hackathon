

# A4DA: Autonomous Adaptive AI-Powered Development Assistant

## Introduction

The **A4DA** (Autonomous Adaptive AI-Powered Development Assistant) is a self-optimizing DevOps system that closes the feedback loop between code quality, deployment, and AI agent fine-tuning. This project integrates cutting-edge AI orchestration (Cline, Kestra) with a custom Reinforcement Learning (RL) agent (Oumi) to continuously improve the quality of future development advice.

**A4DA ensures that every code commit makes the AI smarter, making the CI/CD pipeline truly intelligent.**

## Hackathon Awards Addressed

This project is built using a fully integrated pipeline across all major sponsor technologies.

| Tool | Focus |
| :--- | :--- |
| **Cline CLI** | Full orchestration of the CI/CD pipeline, Vercel deployment, secure Kestra triggering, and autonomous code fixing. |
| **Kestra** | Data flow that runs the LLM to generate the `reward_signal` and Code Lore Narrative, acting as a unified orchestration platform for the entire business logic. |
| **Oumi RL Agent** | Implementation of the Reinforcement Learning Loop to receive the reward signal and simulate fine-tuning the LLM based on performance. |
| **Vercel** | Automated static site deployment, serving as the fast, no-fuss hosting solution that verifies the CI/CD success. |
| **CodeRabbit** | Demonstrated through autonomous code style fixing and high-quality, maintainable integration logic by providing instant, context-aware code reviews on Pull Requests. |


## Architecture Overview

A4DA operates in a full circle, ensuring continuous feedback:

1.  **Code Commit** $\rightarrow$ **Code Review (CodeRabbit):** CodeRabbit provides immediate, high-quality review feedback on all branches and Pull Requests.
2.  **GitHub Action (Cline):** A push to `main` triggers the CI/CD pipeline.
3.  **Orchestration (Cline):** Cline deploys the static site to **Vercel**, then securely fetches a JWT token to trigger the **Kestra** flow.
4.  **Intelligence (Kestra):** The flow fetches GitHub PR data and runs the **AI Agent** (`analyze_and_reward`) to generate a quality score (`reward_signal`) and a story (`code_lore_narrative`).
5.  **Feedback Loop (Oumi):** Kestra posts the reward signal to the local **Oumi RL Server**. Oumi processes the signal to simulate model fine-tuning and closes the loop.
6.  **Autonomous Correction (Cline Autofix Job):** Separately, the `autofix-job` runs the Cline agent to autonomously fix code style issues and create a Pull Request, demonstrating self-healing capability.

## 🛠️ Quick Start & Setup

The A4DA requires several services to run concurrently for the end-to-end autonomous loop test.

### Prerequisites

You must have the following tools installed:

  * **Git** and **Node.js (v20+)**
  * **Python 3.10+** and **pip**
  * **Docker** (to run Kestra)
  * **LLM API Key** (e.g., OpenAI) with **Active Billing** (to run the Cline Agent)

### Step 1: Clone the Repository

```bash
git clone https://github.com/KulkarniShrinivas/A4DA-Self-Optimizing-DevOps-Hackathon.git
cd A4DA-Self-Optimizing-DevOps-Hackathon
```

### Step 2: Configure Local Environment Variables

The Kestra flow requires several secrets to be passed via Docker. **Flow secrets must be Base64-encoded**.

```bash
# 1. Base64 Encode the flow secrets (replace YOUR_VALUES)
export GITHUB_PAT_READ_ENCODED=$(echo -n "ghp_YOUR_GITHUB_PAT" | base64 -w 0)
export OPENAI_KEY_ENCODED=$(echo -n "sk-YOUR_OPENAI_KEY" | base64 -w 0)
export OUMI_ENDPOINT_ENCODED=$(echo -n "http://127.0.0.1:5000/reward" | base64 -w 0)

# 2. Define Kestra Login Credentials
export KESTRA_USERNAME="YOUR_KESTRA_USERNAME"
export KESTRA_PASSWORD="YOUR_KESTRA_PASSWORD"
```

### Step 3: Start the Oumi RL Server (Step 4)

This starts the Python server that receives the final reward signal.

```bash
# Install Python dependencies
pip install -r a4da_oumi_server/requirements.txt

# Start the server (MUST remain running throughout the test)
cd a4da_oumi_server
python llm_server.py
```

  * **Verification:** The terminal will show `* Running on http://127.0.0.1:5000`.

### Step 4: Start the Kestra Server (Step 3)

Start Kestra using the `docker run` command, passing all the required secrets:

```bash
docker run --pull=always --rm -it -p 8080:8080 \
  -e SECRET_GITHUB_PAT_READ="$GITHUB_PAT_READ_ENCODED" \
  -e SECRET_KESTRA_OPENAI_API_KEY="$OPENAI_KEY_ENCODED" \
  -e SECRET_OUMI_RL_TRAINING_ENDPOINT="$OUMI_ENDPOINT_ENCODED" \
  -e KESTRA_USERNAME="$KESTRA_USERNAME" \
  -e KESTRA_PASSWORD="$KESTRA_PASSWORD" \
  kestra/kestra:latest server local
```

  * **Verification:** Check `http://localhost:8080`. The `A4DA_CodeHealth` flow should be visible.

### Step 5: Run the End-to-End Test (Manual Trigger)

You can manually trigger the orchestrator logic after installing the necessary CLIs (`npm install -g cline vercel`).

1.  **Authenticate Cline:**
    ```bash
    cline auth --apikey YOUR_OPENAI_KEY --provider openai-native --modelid gpt-4o
    ```
2.  **Execute the Orchestrator Script:**
    ```bash
    cline run .github/scripts/deploy_and_trigger.sh --yolo
    ```

<!-- end list -->

  * **Expected Outcome:** The script runs. Check Kestra UI for execution and the Oumi server terminal for the **final analysis printout**.

## 🚀 Usage (GitHub Autonomous Trigger)

The ultimate proof is a push to `main`, which triggers the full CI/CD loop:

1.  **Commit Code** $\rightarrow$ **Push to `main`**.
2.  **Monitor GitHub Actions.**
3.  **Verification:** Vercel is deployed, a new Kestra execution starts, and your local Oumi server prints the final analysis.

## 📂 Repository Structure

| Directory/File | Purpose |
| :--- | :--- |
| **`.github/`** | Contains GitHub Actions workflows and automation scripts (Cline orchestration, JWT generation). |
| **`.kestra/flows/`** | Contains the core data flow logic: `codebase_health.yml` (the Kestra AI Agent). |
| **`a4da_oumi_server/`**| The standalone Python/Flask backend housing the **Oumi RL Agent** logic. |
| **`vercel.json`** | Configuration file telling Vercel to use the local `build` folder. |

-----

## Authors & Acknowledgments

  * **Shrinivas Kulkarni** (Developer)

Thank you to the sponsors **Cline**, **Kestra**, **Oumi**, **Vercel**, and **CodeRabbit** for powering this autonomous system\!

The video below explains how to format your code blocks in Markdown, which is essential for a professional README file. [Code Blocks + Syntax Highlighting — Mastering Markdown](https://www.youtube.com/watch?v=9eucl-HyNAM)

http://googleusercontent.com/youtube_content/3
