#!/bin/bash

# Ask the user for the location of the new project
read -rp "Enter the full path for the new project: " PROJECT

# Check if the path is provided
if [ -z "$PROJECT" ]; then
    echo "No path provided. Exiting."
    exit 1
fi

# Create the project and .devcontainer directories if they don't exist
mkdir -p "$PROJECT/.devcontainer"

# Copy the devcontainer.json
if [ -f ~/.dotfiles/configs/devcontainer/linux/devcontainer.json ]; then
    cp ~/.dotfiles/configs/devcontainer/linux/devcontainer.json "$PROJECT/.devcontainer/devcontainer.json"
    echo "Copied devcontainer.json"
else
    echo "Warning: devcontainer.json not found in ~/.dotfiles/configs/devcontainer/linux/"
fi

# Copy the Dockerfile
if [ -f ~/.dotfiles/configs/devcontainer/linux/Dockerfile ]; then
    cp ~/.dotfiles/configs/devcontainer/linux/Dockerfile "$PROJECT/.devcontainer/Dockerfile"
    echo "Copied Dockerfile"
else
    echo "Warning: Dockerfile not found in ~/.dotfiles/configs/devcontainer/linux/"
fi

# Copy the requirements.txt
if [ -f ~/.dotfiles/configs/devcontainer/linux/requirements.txt ]; then
    cp ~/.dotfiles/configs/devcontainer/linux/requirements.txt "$PROJECT/requirements.txt"
    echo "Copied requirements.txt"
else
    echo "Warning: requirements.txt not found in ~/.dotfiles/configs/devcontainer/linux/"
fi

# Copy the requirements.yml
if [ -f ~/.dotfiles/configs/devcontainer/linux/requirements.yml ]; then
    cp ~/.dotfiles/configs/devcontainer/linux/requirements.yml "$PROJECT/requirements.yml"
    echo "Copied requirements.yml"
else
    echo "Warning: requirements.yml not found in ~/.dotfiles/configs/devcontainer/linux/"
fi
# Copy private_key
if [ -f ~/.dotfiles/certs/private_key ]; then
    cp ~/.dotfiles/certs/private_key "$PROJECT/private_key"
    echo "Copied private_key"
else
    echo "Warning: private_key not found in ~/.dotfiles/certs"
fi
# Copy CatoNetworksTrustedRootCA
if [ -f ~/.dotfiles/certs/CatoNetworksTrustedRootCA.pem ]; then
    cp ~/.dotfiles/certs/CatoNetworksTrustedRootCA.pem "$PROJECT/CatoNetworksTrustedRootCA.pem"
    echo "Copied CatoNetworksTrustedRootCA.pem"
else
    echo "Warning: CatoNetworksTrustedRootCA.pem not found in ~/.dotfiles/certs"
fi

echo "Initialization complete!"
