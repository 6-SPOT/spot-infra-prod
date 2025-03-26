variable "type" {
  description = "ALB(application) or NLB(network)"
  type        = string
}

variable "is_internal" {
  description = "ture -> internalLB, false -> externalLB"
  type        = bool
}

variable "subnets" {
  description = "subnet list"
  type        = list(string)
}

variable "certificate_arn" {
  description = "외부LB 사용시 SSL 인증서"
  type        = string
  default     = null
}

variable "name" {
  description = "project name"
  type        = string
}

variable "security_groups" {
  description = "lb에 적용된 sg"
  type        = list(string)
}

variable "enable_https" {
  type    = bool
  default = true
}

variable "enable_logging" {
  type    = bool
  default = false
}

variable "logging" {
  type = object({
    log_prefix = string
  })
  default = null
}

variable "bucket" {
  description = "로그를 수집할때 필요한 버킷입니다."
  type        = string
  default     = null
}
