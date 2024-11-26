#!/bin/bash

# Log file
LOG_FILE="/var/log/sops_encrypt.log"

# Prompt the user for the filename
read -p "Enter the filename (without extension): " FILENAME

# Define paths
SOPS_CONFIG="/home/pungkula/.config/sops/age/.sops.yaml"
OUTPUT_DIR="/home/pungkula/duckOS/flake/secrets"
INPUT_DIR="/var/lib/sops-nix/secrets"

# Log the start time and the filename
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting encryption for $FILENAME" >> "$LOG_FILE"

# Run the SOPS command
sops --config "$SOPS_CONFIG" \
     --output-type json \
     --input-type yaml \
     --output "$OUTPUT_DIR/$FILENAME.json" \
     -e "$INPUT_DIR/$FILENAME.yaml" 2>>"$LOG_FILE"

# Check command success and log the outcome
if [ $? -eq 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Encryption successful: $OUTPUT_DIR/$FILENAME.json" >> "$LOG_FILE"
  echo "Encryption successful: $OUTPUT_DIR/$FILENAME.json"
else
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Error occurred during encryption for $FILENAME" >> "$LOG_FILE"
  echo "Error occurred during encryption."
fi

