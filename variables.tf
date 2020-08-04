
locals {
  environment = terraform.workspace
  CommonTags = {
    Environment = local.environment
    Project = "GepNet"
    Owner = "terraform-managed"
  }
}

variable "database_password" {
  type = string
  default = "1234567890"
}

variable "new_password" {
  type = bool
  default = true
}

variable "database_username" {
  type = string
  default = "postgres"
}

variable "database_name" {
  type = string
  default = "gepnet_software_publico"
}

variable "gepnet_repository" {
  type = string
  default = "https://github.com/spbgovbr/gepnet.git"
}

variable "access_key" {
  type = string
  default = "MacMini"
}
