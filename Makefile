# ==============================================================================
# Sovereign Factory Makefile (Hardened Template)
# ==============================================================================
# Unified choreography for high-velocity, high-integrity missions.
# ==============================================================================

PYTHON_BIN := $(shell which python3.11 || which python3)
PIP := $(PYTHON_BIN) -m pip
DBT := /usr/local/bin/dbt

.PHONY: setup doctor dev-check clean

# 🏮 setup: Initialize the factory floor
setup:
	@echo "🛡️ Initializing Factory..."
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@echo "✅ Setup complete."

# 🩺 doctor: Verify factory environment health
doctor:
	@echo "🛡️ Auditing Factory environment..."
	@$(PYTHON_BIN) --version
	@$(DBT) --version || echo "🔴 dbt-core: MISSING"
	@python3 -m pip list | grep -E "dlt|duckdb|pandas" || echo "🔴 Missing core dependencies"
	@echo "✅ Environment synchronized."

# 🛡️ dev-check: Perform technical audit of the local warehouse
dev-check:
	@echo "🛡️ Executing Dev Certification..."
	./bin/clean_run.sh $(PYTHON_BIN) bin/triple_seal.py --sampled
	@echo "✅ Factory floor certified."

# 🧹 clean: Purge local artifacts
clean:
	rm -rf .ignored/warehouse_local.duckdb
	find . -type d -name "__pycache__" -exec rm -rf {} +
	@echo "🧹 Factory floor cleared."
