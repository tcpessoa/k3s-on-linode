#!/bin/bash

PROJECT_ROOT="."

# Create the directory structure
mkdir -p ${PROJECT_ROOT}/{terraform,ansible/{inventory,roles/{k3s,monitoring,vpn},playbooks},k8s/{namespaces,deployments,services,ingress}}

# Create placeholder files
touch ${PROJECT_ROOT}/terraform/{main.tf,variables.tf,outputs.tf,providers.tf}
touch ${PROJECT_ROOT}/ansible/{ansible.cfg,playbooks/{setup.yml,update.yml}}
touch ${PROJECT_ROOT}/ansible/inventory/hosts.yml
touch ${PROJECT_ROOT}/README.md

echo "Project structure created:"
tree ${PROJECT_ROOT}
