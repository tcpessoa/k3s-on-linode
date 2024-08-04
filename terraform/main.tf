resource "linode_instance" "k3s" {
  image  = "linode/ubuntu24.04"
  label  = "k3s-node"
  region = "eu-central" # Frankfurt region
  type   = "g6-standard-1" # Linode 2 GB

  authorized_keys = [chomp(file(var.ssh_public_key))]

  tags = ["k3s"]

  provisioner "local-exec" {
    command = "echo [k3s] > ../ansible/inventory/hosts.yml && echo ${self.ip_address} ansible_user=root >> ../ansible/inventory/hosts.yml"
  }
}

resource "linode_firewall" "k3s_firewall" {
  label = "k3s-firewall"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  linodes = [ linode_instance.k3s.id ]

 inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
  }
  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
  }
  inbound {
    label  = "allow-wireguard"
    action = "ACCEPT"
    protocol = "UDP"
    ports  = "51820"
    ipv4     = ["0.0.0.0/0"]
  }
  inbound {
    label  = "allow-wireguard-ui"
    action = "ACCEPT"
    protocol = "TCP"
    ports  = "51821"
    ipv4     = ["0.0.0.0/0"]
  }
}

output "server_ip" {
  value = linode_instance.k3s.ip_address
}
