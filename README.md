# k3s-on-linode

<p align="center">
<img src="./docs/k3s.png" alt="k3s" height="100"/>
<img src="./docs/linode.png" alt="linode" height="100"/>
</p>


This project provides Infrastructure as Code (IaC) scripts to deploy a K3s Kubernetes cluster on Linode using Terraform and Ansible. It sets up a single-node K3s cluster with monitoring, a VPN, and other essential components for a production-ready Kubernetes environment.

## Features

- Automated deployment of a K3s node on Linode
- Integrated monitoring stack with Prometheus, Loki (with Promtail) and Grafana.
- WireGuard VPN for secure cluster access
- Cert-Manager for automatic SSL/TLS certificate management
- Traefik as the Ingress Controller
- Linode CSI Driver for dynamic volume provisioning
- CloudFlare pointing to your VPS with full SSL encryption

## Default dashboards included

View metrics of the VPS via NodeExporter:
![Node Exporter Metrics](./docs/NodeExporterMetrics.png)

Search for logs across all your pods thanks to Loki with Promtail:
![Logs with Loki](./docs/LogsWIthLoki.png)

## Prerequisites

- [Terraform](https://www.terraform.io/) (v1.9+)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.17.2+)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- A Linode account and API token
- A CloudFlare account and API token
- A domain with CloudFlare as the DNS provider

## Getting Started

1. Clone this repository:
   ```sh
   git clone https://github.com/tcpessoa/k3s-on-linode.git
   cd k3s-on-linode
   ```

2. Create a python virtual environment and activate it. Run `pip install -r requirements.txt`

3. Run the setup script:
   ```sh
   ./setup.sh
   ```

4. Edit the configuration files:
   Add your Linode API token and SSH key path to `terraform/terraform.tfvars`.

   Run:

   ```sh
   ansible-vault edit ansible/group_vars/all/vault.yml --vault-password-file ansible/.vault_password
   ```

   To set passwords and other sensitive information.

5. Deploy the infrastructure:
   ```sh
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

6. Deploy K3s and additional components:
   ```sh
   cd ../ansible
   ansible-playbook playbooks/setup.yml
   ```

7. Retrieve the kubeconfig:
   ```sh
   ansible-playbook playbooks/retrieve_configs.yml
   ```

8. Access your cluster:
   - Go ahead and visit `https://test.<main-domain>.com`
   - Check metrics at `https://grafana.<main-domain>.com`
   - Set up WireGuard VPN using the web UI at `http://<LINODE_IP>:51821` or `https://wireguard.<main-domain>.com`
   - Use the kubeconfig file in `ansible/playbooks/configs/kubeconfig` or run `./merge-kubeconfig.sh` to append the new config.

# Troubleshoot
- Run `ansible-playbook -vvvv ...` to increase verbosity of commands
- Run `ansible-playbook -vvv playbooks/debug_role.yml` with the desired role to debug a single step
- Run `terraform state rm 'cloudflare_zone_settings_override.domain_settings["example.com"]'` to clean up state

# Ansible
## Server things

### Basic system-wide security settings sysctl

1. `net.ipv4.conf.all.accept_redirects = 0`

Disables acceptance of ICMP redirects for all interfaces.
Purpose: Prevents potential man-in-the-middle attacks where an attacker could redirect traffic.


2. `net.ipv4.conf.all.send_redirects = 0`

Disables sending of ICMP redirects for all interfaces.
Purpose: Prevents the system from sending ICMP redirects, which could potentially be used to reveal information about the network topology.


3. `net.ipv4.conf.all.accept_source_route = 0`

Disables acceptance of source-routed packets for all interfaces.
Purpose: Prevents source routing, which could be used to bypass network security measures.


4. `net.ipv4.tcp_syncookies = 1`

Enables TCP SYN cookies.
Purpose: Helps protect against SYN flood attacks by validating connection attempts without using memory until the connection is fully established.

# Improvements
- [ ] Automatically generate VPN conf file and get it (generating the wg conf is more complex then I imagined)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [K3s](https://k3s.io/)
- [Linode](https://www.linode.com/)
- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
