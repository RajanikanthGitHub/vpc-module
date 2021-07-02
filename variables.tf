variable "vpc_cidr" {
  default = "10.0.0.0/24"
}

variable "tenancy" {
  default = "dedicated"
}

variable "vpc_id" {}

variable "publicsubnet_cidr" {
  default = "10.0.1.0/24"
}

variable "privateubnet_cidr" {
}
