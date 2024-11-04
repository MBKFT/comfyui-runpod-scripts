#!/bin/bash

# Set error handling
set -euo pipefail

# Log function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Setup directories
setup_directories() {
    log "Creating directory structure..."
    mkdir -p /workspace/ComfyUI/custom_nodes
    mkdir -p /workspace/ComfyUI/models/checkpoints
    mkdir -p /workspace/ComfyUI/models/loras
    mkdir -p /workspace/ComfyUI/models/controlnet
    mkdir -p /workspace/ComfyUI/models/upscale_models
    mkdir -p /workspace/logs
}

# Install custom nodes
install_custom_nodes() {
    log "Installing custom nodes..."
    cd /workspace/ComfyUI/custom_nodes

    # Array of repositories to clone
    declare -A repositories=(
        ["ComfyUI-Impact-Pack"]="https://github.com/ltdrdata/ComfyUI-Impact-Pack.git"
        ["WAS-Node-Suite"]="https://github.com/WASasquatch/was-node-suite.git"
        ["ComfyUI-Manager"]="https://github.com/ltdrdata/ComfyUI-Manager.git"
    )

    # Clone or pull each repository
    for repo_name in "${!repositories[@]}"; do
        if [ ! -d "$repo_name" ]; then
            log "Cloning $repo_name..."
            git clone "${repositories[$repo_name]}" "$repo_name"
        else
            log "Updating $repo_name..."
            cd "$repo_name"
            git pull
            cd ..
        fi
    done
}

# Download base models
download_models() {
    log "Downloading base models..."
    cd /workspace/ComfyUI/models/checkpoints

    # Array of models to download
    declare -A models=(
        ["sd_xl_base_1.0.safetensors"]="https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
        ["v1-5-pruned.safetensors"]="https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors"
    )

    # Download each model if it doesn't exist
    for model_name in "${!models[@]}"; do
        if [ ! -f "$model_name" ]; then
            log "Downloading $model_name..."
            wget -nc "${models[$model_name]}" -O "$model_name"
        else
            log "$model_name already exists, skipping..."
        fi
    done
}

# Main execution
main() {
    setup_directories
    install_custom_nodes
    download_models
}

main