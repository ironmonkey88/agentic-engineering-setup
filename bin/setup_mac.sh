#!/bin/bash
# 🏮 setup_mac.sh: The Sovereign Factory Bootstrap
# Purpose: Automate the environment hardening for a new agentic mission.

set -e

echo "🏮 Initiating Genetic Setup: Apple Silicon Optimized..."

# 1. Virtual Environment Hardening
if [ ! -d ".venv" ]; then
    echo "🐍 Creating Sovereign Python Environment (.venv)..."
    python3 -m venv .venv
fi
source .venv/bin/python3 -m pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    echo "📦 Satisfying Dependency Manifest (requirements.txt)..."
    .venv/bin/pip install -r requirements.txt
fi

# 2. Secret Sovereignty (direnv)
if [ ! -f ".envrc" ]; then
    if [ -f ".envrc.template" ]; then
        echo "🛡️  Provisioning .envrc from Template..."
        cp .envrc.template .envrc
        echo "⚠️  ACTION REQUIRED: Update .envrc with your secrets and run 'direnv allow'."
    fi
fi

# 3. Registry Certification
echo "🎴 Verifying Worker Genetics..."
if [ -f "bin/verify_worker.py" ]; then
    .venv/bin/python3 bin/verify_worker.py
fi

echo "✅ Genesis Setup Complete. Welcome to the Pulse."
echo "🔗 Access your Master Protocol at: SOVEREIGN_BLUEPRINT.md"
