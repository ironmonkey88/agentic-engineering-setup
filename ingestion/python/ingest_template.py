import dlt
import hashlib
import argparse

def is_in_10pct_sample(val):
    """Deterministic 10% filter using MD5 logic."""
    if not val: return False
    h = hashlib.md5(str(val).encode()).hexdigest()
    return (int(h[:2], 16) % 100) < 10

def fetch_data_generator(source_url, sampled=True):
    """Template generator for paginated extraction."""
    # ... extraction logic ...
    data = [] # Fetch from API
    if sampled:
        data = [row for row in data if is_in_10pct_sample(row.get('id'))]
    yield data

def run_ingestion(config):
    sampled = config.get('sampled', True) # Sampled by default!
    pipeline = dlt.pipeline(
        pipeline_name=config['pipeline_name'],
        destination=dlt.destinations.duckdb(config['db_path']),
        dataset_name="bronze"
    )
    
    # Execute load
    info = pipeline.run(
        fetch_data_generator(config['url'], sampled=sampled),
        table_name=config['table_name'],
        write_disposition="replace"
    )
    print(f"Ingestion Complete: {info}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    # Note: Sampled by default in the Sovereign Factory template
    parser.add_argument("--full", action="store_true", help="Ingest 100% (Production mode)")
    args = parser.parse_args()
    
    # Logic flipped: Default is sampled unless --full is passed
    run_ingestion({
        "pipeline_name": "agentic_mission_refinery",
        "url": "https://api.example.com/v1/resource",
        "db_path": "./.ignored/warehouse_local.duckdb",
        "table_name": "raw_resource",
        "sampled": not args.full 
    })
