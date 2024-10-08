#!/bin/bash
# Description: Merge kubeconfig files


if [ ! -f ./ansible/playbooks/configs/kubeconfig ]; then
    echo "The kubeconfig file from the Linode K3s cluster does not exist."
    echo "The file should be located at ./ansible/playbooks/configs/kubeconfig."
    echo "Please run the Ansible playbook `ansible-playbook retrieve-configs.yml` to get the file."
    exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "kubectl could not be found. Please install it."
    exit 1
fi

# Backup the original kubeconfig file
cp ~/.kube/config ~/.kube/config.bak

# Copy the kubeconfig file from the Linode K3s cluster
cp ./ansible/playbooks/configs/kubeconfig ~/.kube/config-linode-k3s

# Merge the kubeconfig files
KUBECONFIG=~/.kube/config:~/.kube/config-linode-k3s kubectl config view --flatten > ~/.kube/config

echo "k3s on linode config added!"
