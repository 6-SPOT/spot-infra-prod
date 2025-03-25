variable "domain" {
  description = "domain name"
  type        = string
}

variable "validation_method" {
  description = "인증방법을 선택합니다. DNS, EMAIL 둘중 하나입니다."
  type        = string
}

variable "zone_id" {
  description = "route53의 호스팅영역 id"
  type        = string
}

variable "sub_domain" {
  description = "서브도메인 리스트"
  type        = list(any)
}
