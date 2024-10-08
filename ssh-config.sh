#!/bin/bash

# Description: Setup SSH config for Linode K3s cluster
# Add entry to SSH config for Linode K3s cluster

DEFAULT_SSH_USER=user
DEFAULT_SSH_KEY_PATH=~/.ssh/id_ed25519
IP_ADDRESS=$(cd terraform && terraform output -json | jq -r '.server_ip.value')
echo "$IP_ADDRESS"

# Prompt for SSH user and key path
read -p "Enter SSH user (default: $DEFAULT_SSH_USER): " SSH_USER
SSH_USER=${SSH_USER:-$DEFAULT_SSH_USER}

read -p "Enter SSH key path (default: $DEFAULT_SSH_KEY_PATH): " SSH_KEY_PATH
SSH_KEY_PATH=${SSH_KEY_PATH:-$DEFAULT_SSH_KEY_PATH}

# Check if SSH config exists
if [ ! -f ~/.ssh/config ]; then
    echo "Creating SSH config file..."
    touch ~/.ssh/config
fi

# Check if entry already exists

if grep -q "k3s-check" ~/.ssh/config; then
    echo "Host already exists"
    exit 1
else
    echo "Adding entry to SSH config..."
    echo "Host k3s-check" >> ~/.ssh/config
    echo "    HostName $IP_ADDRESS" >> ~/.ssh/config
    echo "    User $SSH_USER" >> ~/.ssh/config
    echo "    IdentityFile $SSH_KEY_PATH" >> ~/.ssh/config
fi
