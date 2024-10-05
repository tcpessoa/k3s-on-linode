variable "linode_token" {
  description = "Linode API token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Path to SSH public key"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_ips" {
  description = "List of Cloudflare IP ranges"
  type        = list(string)
  default     = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22"
  ]
}

variable "main_domain" {
  description = "The main domain for the project"
  type        = string
}

variable "additional_domains" {
  description = "List of additional domains to configure"
  type        = list(string)
  default     = []
}

variable "cloudflare_zone_ids" {
  description = "Map of domain names to their Cloudflare Zone IDs"
  type        = map(string)
}
