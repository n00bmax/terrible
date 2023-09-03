# Variable Definitions

variable "proxmox_api_config" {
  type = object({
    url          = string
    token_id     = string
    token_secret = string
  })
}

variable "template_config" {
  type = object({
    vmid = string
    file_name = string
  })
}

