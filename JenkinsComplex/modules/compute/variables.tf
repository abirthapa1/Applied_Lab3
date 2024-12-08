#----------comput/variables.tf--------------
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_key_public" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_private" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "subnet_ips" {}

variable "security_group" {}

variable "subnets" {}

variable "root_volume_size" {
  description = "Size of the EBS root volume"
  type        = number
  default     = 50
}