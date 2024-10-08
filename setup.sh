#!/bin/bash

# Terraform setup
if [ ! -f terraform/terraform.tfvars ]; then
    echo "Creating terraform.tfvars from example..."
    cp terraform/terraform.tfvars.example terraform/terraform.tfvars
fi

# Ansible setup
if [ ! -f ansible/group_vars/all/vault.yml ]; then
    echo "Creating vault.yml from example..."
    cp ansible/group_vars/all/vault.yml.example ansible/group_vars/all/vault.yml

    echo "Please enter a password for your Ansible Vault:"
    read -s vault_password
    echo $vault_password > ansible/.vault_password

    ansible-vault encrypt ansible/group_vars/all/vault.yml --vault-password-file ansible/.vault_password

    echo "Vault created and encrypted"
fi

# Check for required tools
for cmd in terraform ansible ansible-vault kubectl helm; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd could not be found. Please install it."
        exit 1
    fi
done

echo "Setup complete!"
echo "Please edit terraform/terraform.tfvars with your Linode API token and SSH key path."
echo "ansible-vault edit ansible/group_vars/all/vault.yml --vault-password-file ansible/.vault_password"
