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

variable "sg_config" {
  description = "필요한 보안그룹에 관한 설정입니다."
  type = map(object({
    ingress = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
      description     = optional(string)
    }))
    egress = list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
      description     = optional(string)
    }))
  }))
}