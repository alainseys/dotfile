#!/usr/bin/env bash

# Source files
CERT_FILE="$HOME/.dotfile/certs/CatoNetworksTrustedRootCA.pem"
KEY_FILE="$HOME/.dotfile/certs/private_key"

# Ask user for destination directory
read -rp "Enter destination directory: " DEST_DIR

# Expand ~ if used
DEST_DIR="${DEST_DIR/#\~/$HOME}"

# Check if destination exists
if [ ! -d "$DEST_DIR" ]; then
    echo "Directory does not exist. Creating it..."
    mkdir -p "$DEST_DIR" || {
        echo "Failed to create directory."
        exit 1
    }
fi

# Copy files
cp "$CERT_FILE" "$DEST_DIR/" || {
    echo "Failed to copy certificate file."
    exit 1
}

cp "$KEY_FILE" "$DEST_DIR/" || {
    echo "Failed to copy private key."
    exit 1
}

echo "Files copied successfully to $DEST_DIR"
