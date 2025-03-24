variable "pub_sub" {
  description = "subnet in which to place the NAT"
  type        = string
}

variable "allocation_id" {
  description = "Elastic IP address"
  type        = string
}

variable "az" {
  description = "az"
  type        = string
}

variable "name" {
  description = "project name"
  type        = string
}
