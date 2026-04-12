# Automatically load environment variables if .env exists
ifneq ("$(wildcard .env)","")
	include .env
	export $(shell sed 's/=.*//' .env)
endif

setup:
	@echo "🏮 Bootstrapping Sovereign Factory..."
	bash bin/setup_mac.sh
	@echo "✅ Setup complete."

install:
	@echo "Installing python dependencies..."
	pip install --upgrade pip
	pip install -r requirements.txt

dev-check:
	@echo "🛡️  Auditing Environment Sovereignty..."
	@command -v dbt >/dev/null 2>&1 && dbt --version || echo "⚠️  dbt missing"
	@command -v bd >/dev/null 2>&1 && bd --version || echo "⚠️  beads (bd) missing"
	@command -v duckdb >/dev/null 2>&1 && duckdb --version | head -n 1 || echo "⚠️  duckdb missing"
	@command -v terraform >/dev/null 2>&1 && terraform version | head -n 1 || echo "⚠️  terraform missing"
	@command -v gcloud >/dev/null 2>&1 && gcloud --version | head -n 1 || echo "⚠️  gcloud missing"

beads-init:
	@bd init

report:
	@echo "📊 Generating Task Beads Report..."
	@bd ready

ship:
	@echo "🚢 Launching Release Pulse..."
	@./bin/release_pulse.sh

portal-ship:
	@echo "🏮 Launching Selective UI Release..."
	@SKIP_EVIDENCE=true ./bin/release_pulse.sh
