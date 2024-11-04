#!/bin/bash

# Set error handling
set -euo pipefail

# Source path for additional scripts
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/scripts"

# Log function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Main initialization
log "Starting ComfyUI provisioning..."

# Run setup nodes script
if [ -f "${SCRIPT_DIR}/setup_nodes.sh" ]; then
    log "Running node setup script..."
    bash "${SCRIPT_DIR}/setup_nodes.sh"
else
    log "Error: setup_nodes.sh not found!"
    exit 1
fi

# Run dependency updates
if [ -f "${SCRIPT_DIR}/update_deps.sh" ]; then
    log "Running dependency updates..."
    bash "${SCRIPT_DIR}/update_deps.sh"
else
    log "Error: update_deps.sh not found!"
    exit 1
fi

log "Provisioning complete!"