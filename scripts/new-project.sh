#!/bin/bash
BASEDIR=$HOME/.dotfile
# Ask the user for the location of the new project
read -rp "Enter the full path for the new project: (/home/$USER/Documents...)" PROJECT

# Check if the path is provided
if [ -z "$PROJECT" ]; then
    echo "No path provided. Exiting."
    exit 1
fi

# Create the project and .devcontainer directories if they don't exist
mkdir -p "$PROJECT/.devcontainer"

# Copy the devcontainer.json
if [ -f "$BASEDIR/configs/devcontainer/devcontainer.json" ]; then
    cp "$BASEDIR/configs/devcontainer/devcontainer.json" "$PROJECT/.devcontainer/devcontainer.json"
    echo "Copied devcontainer.json"
else
    echo "Warning: devcontainer.json not found in $BASEDIR/configs/devcontainer/"
fi

# Copy the Dockerfile
if [ -f "$BASEDIR/configs/devcontainer/Dockerfile" ]; then
    cp "$BASEDIR/configs/devcontainer/Dockerfile" "$PROJECT/.devcontainer/Dockerfile"
    echo "Copied Dockerfile"
else
    echo "Warning: Dockerfile not found in $BASEDIR/configs/devcontainer/"
fi

# Copy the requirements.txt
if [ -f "$BASEDIR/configs/devcontainer/requirements.txt" ]; then
    cp "$BASEDIR/configs/devcontainer/requirements.txt" "$PROJECT/requirements.txt"
    echo "Copied requirements.txt"
else
    echo "Warning: requirements.txt not found in $BASEDIR/configs/devcontainer/"
fi

# Copy the requirements.yml
if [ -f "$BASEDIR/configs/devcontainer/requirements.yml" ]; then
    cp "$BASEDIR/configs/devcontainer/requirements.yml" "$PROJECT/requirements.yml"
    echo "Copied requirements.yml"
else
    echo "Warning: requirements.yml not found in $BASEDIR/configs/devcontainer/"
fi
# Copy private_key
if [ -f "$BASEDIR/certs/private_key" ]; then
    cp "$BASEDIR/certs/private_key" "$PROJECT/private_key"
    echo "Copied private_key"
else
    echo "Warning: private_key not found in $BASEDIR/certs"
fi
# Copy CatoNetworksTrustedRootCA
if [ -f "$BASEDIR/certs/CatoNetworksTrustedRootCA.pem" ]; then
    cp "$BASEDIR/certs/CatoNetworksTrustedRootCA.pem" "$PROJECT/CatoNetworksTrustedRootCA.pem"
    echo "Copied CatoNetworksTrustedRootCA.pem"
else
    echo "Warning: CatoNetworksTrustedRootCA.pem not found in $BASEDIR/certs"
fi

echo "Initialization complete!"
cd "$PROJECT" || exit
