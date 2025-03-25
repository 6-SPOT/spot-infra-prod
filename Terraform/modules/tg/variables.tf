variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "name" {
  description = "project name"
  type        = string
}

variable "port" {
  description = "to port"
  type        = string
}

variable "protocol" {
  description = "Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP. Required when target_type is instance, ip, or alb. Does not apply when target_type is lambda."
  type        = string
}

variable "type" {
  description = "ip or instance"
  type        = string
}

variable "key" {
  description = "map에 key를 이름에 박아 구분합니다."
  type        = string
}

#---

variable "health_path" {
  description = "헬스체크할 경로"
  type        = string
  default     = null
}

variable "expect" {
  description = "예상하는 반환코드"
  type        = string
  default     = "200"
}
