#!/bin/bash

# Update package list
echo "Updating package list..."
sudo dnf update -y

# Install git and python 
echo "Installing git and python..."
sudo dnf install -y git python3 python3-pip python3-virtualenv 

# Install vritualenv using pip3
echo "Installing virtualenv..."
sudo pip3 install --user virtualenv

# Create a virtual environment for ansible
echo "Creating virtual environment for ansible..."
virtualenv ansible-env

# Activate the virtual environment
echo "Activating virtual environment..."
source ansible-env/bin/activate

# Install ansible using pip
echo "Installing ansible..."
pip install ansible


# Show the installed versions to verify the installation
echo "Installed versions:"
git --version
python3 --version
ansible --version