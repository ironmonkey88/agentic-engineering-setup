.PHONY: setup install dev-check check-env report

# Automatically load the .env environment if available
include .envrc

# The setup target can be run even if the venv doesn't exist yet
setup:
	@echo "Bootstrapping fresh Mac environment..."
	bash bin/setup_mac.sh
	@echo "Setup complete. Run 'direnv allow' to activate."

install:
	@echo "Installing python dependencies..."
	pip install --upgrade pip
	pip install -r requirements.txt

dev-check:
	@echo "Auditing environment variables & tool versions..."
	@dbt --version
	@dlt --version
	@gcloud --version | head -n 1
	@dolt version
	@terraform version | head -n 1
	@duckdb --version | head -n 1

report:
	@echo "Generating Dolt Beads Report..."
	@cd beads && dolt sql -q "SELECT RPAD(id, 8, ' ') AS ID, RPAD(status, 11, ' ') AS Status, title AS Task_Description FROM tasks ORDER BY id;"

ship:
	@./bin/release_pulse.sh

portal-ship:
	@SKIP_EVIDENCE=true ./bin/release_pulse.sh
