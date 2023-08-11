provider "proxmox" {
  pm_api_url          = "https://10.0.0.11:8006/api2/json" # change this to match your own proxmox
  pm_api_token_id     = "root@pam!terraform"
  pm_api_token_secret = "a4b0982c-b136-4e79-a319-b245878c91c1"
  pm_tls_insecure     = true
  #  pm_debug = true
}