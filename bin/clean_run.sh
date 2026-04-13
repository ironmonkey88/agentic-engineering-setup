#!/bin/bash
# ==============================================================================
# Wong Way Clean Run Hygiene Wrapper (Technical Shield)
# ==============================================================================
# Use this to execute terminal commands while stripping accidental instruction
# leakage or model persona noise.
#
# Usage: ./bin/clean_run.sh [COMMAND] [ARGS...]
# ==============================================================================

# Normalization-aware word-level exclusion matrix
EXCLUSIONS=(
    "leadership" "personas" "session" "phase" "retrospective" "main" "of"
    "the" "subagent" "requested" "by" "user" "project" "with"
)

CLEAN_ARGS=()
for arg in "$@"; do
    # Strip trailing punctuation for normalized comparison
    norm_arg=$(echo "$arg" | sed 's/[.,:]$//' | tr '[:upper:]' '[:lower:]')
    
    keep=true
    for ex in "${EXCLUSIONS[@]}"; do
        if [ "$norm_arg" == "$ex" ]; then
            keep=false
            break
        fi
    done
    
    if $keep; then
        CLEAN_ARGS+=("$arg")
    fi
done

# Execute certified command
"${CLEAN_ARGS[@]}"
