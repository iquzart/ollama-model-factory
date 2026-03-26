#!/usr/bin/env bash

set -euo pipefail

# -------- colors --------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

DIVIDER="========================================"
SEPARATOR="----------------------------------------"

# -------- colored output helpers --------
info() { echo -e "${CYAN}$*${RESET}"; }
success() { echo -e "${GREEN}$*${RESET}"; }
warn() { echo -e "${YELLOW}$*${RESET}"; }
error() { echo -e "${RED}$*${RESET}"; }
bold() { echo -e "${BOLD}$*${RESET}"; }

# -------- usage --------
usage() {
  echo "$DIVIDER"
  bold "Usage:"
  echo "  $0 <model> [tag]"
  echo ""
  bold "Description:"
  echo "  Build an Ollama model from models/Modelfile.<model>"
  echo "  Automatically generates model name and tag."
  echo ""
  bold "Arguments:"
  echo "  <model>    Model name (required)"
  echo "  [tag]      Optional tag (default: current date YYYY-MM-DD)"
  echo ""
  bold "Examples:"
  echo "  $0 qwen3-optimized"
  echo "  $0 qwen3-optimized v1"
  echo "  $0 llama3-devops 2026-03-26"
  echo "$DIVIDER"
}

# -----------------------------
# Args
# -----------------------------
MODEL="${1:-}"
TAG_INPUT="${2:-}"

# Help flag
if [[ "${MODEL}" == "-h" || "${MODEL}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ -z "$MODEL" ]]; then
  error "Missing required argument: <model>"
  echo ""
  usage
  exit 1
fi

# Default tag = current date
TAG="${TAG_INPUT:-$(date +%Y-%m-%d)}"

# File naming convention
MODELFILE="models/Modelfile.${MODEL}"

# Construct final model name
MODEL_NAME="${MODEL}:${TAG}"

# -----------------------------
# Validation
# -----------------------------
if [[ ! -f "$MODELFILE" ]]; then
  error "Modelfile not found: $MODELFILE"
  exit 1
fi

# -----------------------------
# Info
# -----------------------------
echo "$DIVIDER"
bold "Building Ollama Model"
echo "$SEPARATOR"
info "Input Model : $MODEL"
info "Tag         : $TAG"
info "Model Name  : $MODEL_NAME"
info "Modelfile   : $MODELFILE"
echo "$DIVIDER"
echo ""

# -----------------------------
# Build
# -----------------------------
info "Running: ollama create $MODEL_NAME -f $MODELFILE"
echo ""

ollama create "$MODEL_NAME" -f "$MODELFILE"

# -----------------------------
# Done
# -----------------------------
echo ""
success "Model built successfully"
echo "Run:"
bold "  ollama run $MODEL_NAME"
echo ""
