#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="${SCRIPT_DIR}/.tflint.hcl"
echo "### tflint --init ###"
tflint --init
echo "### tflint --config "${CONFIG_PATH}" --recursive ###"
tflint --config "${CONFIG_PATH}" --recursive