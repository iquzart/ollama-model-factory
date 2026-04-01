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

# -------- helpers --------
info() { echo -e "${CYAN}$*${RESET}"; }
success() { echo -e "${GREEN}$*${RESET}"; }
warn() { echo -e "${YELLOW}$*${RESET}"; }
error() { echo -e "${RED}$*${RESET}"; }
bold() { echo -e "${BOLD}$*${RESET}"; }

MODEL_DIR="./models"

usage() {
  echo "$DIVIDER"
  bold "Usage:"
  echo "  $0"
  echo ""
  bold "Options:"
  echo "  - Select a model to build"
  echo "  - Or choose ALL to build all models"
  echo ""
  bold "Naming convention:"
  echo "  Modelfile.qwen25-stable → qwen25:stable"
  echo "$DIVIDER"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

# -----------------------------
# Discover models
# -----------------------------
if [[ ! -d "$MODEL_DIR" ]]; then
  error "Models directory not found: $MODEL_DIR"
  exit 1
fi

mapfile -t FILES < <(ls "$MODEL_DIR"/Modelfile.* 2>/dev/null || true)

if [[ ${#FILES[@]} -eq 0 ]]; then
  error "No Modelfile.* found in $MODEL_DIR"
  exit 1
fi

# -----------------------------
# List models
# -----------------------------
echo "$DIVIDER"
bold "Available Models"
echo "$SEPARATOR"

MODELS=()
i=1

for file in "${FILES[@]}"; do
  name=$(basename "$file" | sed 's/Modelfile\.//')
  MODELS+=("$name")
  echo "$i) $name"
  ((i++))
done

echo ""
echo "a) ALL models"
echo "$DIVIDER"
echo ""

# -----------------------------
# Selection
# -----------------------------
read -p "Select a model (1-${#MODELS[@]} or 'a' for all): " choice

build_model() {
  local MODEL="$1"
  local MODELFILE="$MODEL_DIR/Modelfile.$MODEL"

  if [[ "$MODEL" != *-* ]]; then
    error "Invalid model format: $MODEL"
    return 1
  fi

  local BASE="${MODEL%%-*}"
  local TAG="${MODEL#*-}"
  local MODEL_NAME="${BASE}:${TAG}"

  echo ""
  echo "$DIVIDER"
  bold "Building Model: $MODEL_NAME"
  echo "$SEPARATOR"

  info "Modelfile: $MODELFILE"
  info "Running: ollama create $MODEL_NAME -f $MODELFILE"
  echo ""

  ollama create "$MODEL_NAME" -f "$MODELFILE"

  success "Built: $MODEL_NAME"
}

# -----------------------------
# Execute selection
# -----------------------------
if [[ "$choice" == "a" || "$choice" == "A" ]]; then
  bold "Building ALL models..."
  echo "$DIVIDER"

  for MODEL in "${MODELS[@]}"; do
    build_model "$MODEL"
  done

  echo ""
  success "All models built successfully"
  echo "$DIVIDER"

elif [[ "$choice" =~ ^[0-9]+$ ]]; then
  if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#MODELS[@]}" ]; then
    error "Invalid selection"
    exit 1
  fi

  MODEL="${MODELS[$((choice - 1))]}"
  build_model "$MODEL"

  echo ""
  success "Model build completed"
  echo "$DIVIDER"

else
  error "Invalid input"
  exit 1
fi
