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

variable "domain" {
  description = "도메인이름"
  type        = string
}

variable "sub_domain" {
  description = "서브도메인이름"
  type        = list(any)
}

variable "route53_zone_id" {
  description = "route53의 호스팅 영역 ID입니다. route 53을 TF으로 관리하고있지않아서 직접 값을 넣어야합니다."
  type        = string
}

variable "validation_method" {
  description = "SSL인증서 유효확인 방법, DNS/EMAIL 택일"
  type        = string
}
