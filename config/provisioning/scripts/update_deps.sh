#!/bin/bash

# Set error handling
set -euo pipefail

# Log function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Update pip
update_pip() {
    log "Updating pip..."
    python -m pip install --upgrade pip
}

# Install/update requirements
install_requirements() {
    log "Installing/updating requirements..."
    cd /workspace
    find . -name 'requirements.txt' -execdir pip install -r {} \;
}

# Install additional dependencies
install_additional_deps() {
    log "Installing additional dependencies..."
    
    # List of additional packages
    declare -a packages=(
        "insightface"
        "numpy==1.25.2"
        "opencv-python"
        "torch torchvision torchaudio"
        "transformers"
    )

    for package in "${packages[@]}"; do
        log "Installing $package..."
        pip install $package
    done
}

# Main execution
main() {
    update_pip
    install_requirements
    install_additional_deps
}

main