### prod
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "name" {
  description = "Name prefix for resoucres"
  type        = string
  default     = "my"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/24"
}

variable "public_sub" {
  description = "public_subnet CIDR block"
  type = map(object({
    cidr   = string
    az     = string
    public = bool
  }))
}

variable "private_sub" {
  description = "private_subnet CIDR block"
  type = map(object({
    cidr   = string
    az     = string
    public = bool
  }))
}