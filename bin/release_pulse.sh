#!/usr/bin/env bash
# [ASSEMBLER] Release Pulse (The Build-to-Bucket Pipeline) 🏮
# Purpose: Automate the delivery of static civic assets to the public portal.

set -e # Exit on error

echo "🏮 Starting Release Cycle: Public Civic Pulse..."

# 1. Environment Detection
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORTAL_BUCKET="gs://civicpulse-somerville-io"
EVIDENCE_DIR="$PROJECT_DIR/analytics/evidence"

echo "📂 Project Directory: $PROJECT_DIR"
echo "📂 Evidence Directory: $EVIDENCE_DIR"
echo "📂 Portal Bucket: $PORTAL_BUCKET"

# 2. Build the Evidence Reports
if [ "$SKIP_EVIDENCE" = "true" ]; then
    echo "⏩ Skipping Evidence Reports build (Selective Deployment)..."
else
    echo "🏗️  Building Evidence Reports (Static Generation)..."
    cd "$EVIDENCE_DIR"
    npm run build
fi

# 3. Synchronize Portal Assets
echo "🚢 Synchronizing Portal Assets (Landing Page & Design)..."
gsutil -m rsync -r "$PROJECT_DIR/portal/" "$PORTAL_BUCKET/"

# 4. Synchronize Evidence Reports (Into /reports/ subdirectory)
echo "🚢 Synchronizing Evidence Reports (Data Products)..."
gsutil -m rsync -r "$EVIDENCE_DIR/build/" "$PORTAL_BUCKET/reports/"

# 5. Set Cache Control (Sub-second Performance)
echo "🛡️  Optimizing Cache Headers (24 Hour Freshness for HTML)..."
gsutil -m setmeta -h "Cache-Control:public, max-age=86400" "$PORTAL_BUCKET/**/*.html"

echo "🛡️  Hardening Static Assets (1 Year Immutability for JS/CSS)..."
gsutil -m setmeta -h "Cache-Control:public, max-age=31536000, immutable" "$PORTAL_BUCKET/**/*.{js,css,woff2}" || true

echo "✅ Release Cycle Complete: Mission Accomplished."
echo "🔗 Access your portal at: https://civicpulse.thewongway.co"
