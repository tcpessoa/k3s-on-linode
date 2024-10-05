resource "linode_instance" "k3s" {
  image  = "linode/ubuntu24.04"
  label  = "${var.main_domain}-k3s"
  region = "eu-central" # Frankfurt region
  type   = "g6-standard-1" # Linode 2 GB

  authorized_keys = [chomp(file(var.ssh_public_key))]

  tags = ["k3s"]

  provisioner "local-exec" {
    command = "echo [k3s] > ../ansible/inventory/hosts.yml && echo ${self.ip_address} ansible_user=root >> ../ansible/inventory/hosts.yml"
  }
}

resource "linode_firewall" "k3s_firewall" {
  label  = "${var.main_domain}-k3s-firewall"
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
     label    = "allow-http-https"
     action   = "ACCEPT"
     protocol = "TCP"
     ports    = "80,443"
     ipv4     = var.cloudflare_ips
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

## Cloudfare linking
locals {
  all_domains = concat([var.main_domain], var.additional_domains)
}

resource "cloudflare_record" "domain_a" {
  for_each = toset(local.all_domains)
  zone_id  = var.cloudflare_zone_ids[each.key]
  name     = "@"
  content    = linode_instance.k3s.ip_address
  type     = "A"
  proxied  = true
}

resource "cloudflare_record" "domain_cname" {
  for_each = toset(local.all_domains)
  zone_id  = var.cloudflare_zone_ids[each.key]
  name     = "*"
  content  = each.key
  type     = "CNAME"
  proxied  = true
}

resource "cloudflare_zone_settings_override" "domain_settings" {
  for_each = toset(local.all_domains)
  zone_id  = var.cloudflare_zone_ids[each.key]
  settings {
    ssl = "full"
  }
}

output "server_ip" {
  value = linode_instance.k3s.ip_address
}
