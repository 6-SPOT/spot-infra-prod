variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "egress" {
  description = "나갈수있는 규칙"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    description     = optional(string)
  }))
}

variable "ingress" {
  description = "들어올 수 있는 규칙"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    description     = optional(string)
  }))
}

variable "sg_name" {
  description = "name"
  type        = string
}

variable "name" {
  description = "name"
  type        = string
}
