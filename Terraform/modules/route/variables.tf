variable "vpc_id" {
  description = "라우팅 테이블이 위치할 vpc에 대한 정보"
  type        = string
}

variable "igw_id" {
  description = "igw_id 입니다, 퍼블릭일땐 넣어야합니다."
  type        = string
  default     = null
}

variable "nat_id" {
  description = "nat_id 입니다. 프라이빗일땐 넣어야합니다."
  type        = string
  default     = null
}


variable "name" {
  description = "프로젝트 이름"
  type        = string
}

variable "subnet_id" {
  description = "연결될 서브넷 목록입니다."
  type        = list(any)
}

variable "az" {
  description = "az, 프라이빗일땐 넣어야합니다."
  type        = string
  default     = null
}

variable "is_public" {
  description = "퍼블릭인지 판단하는 플래그"
  type        = bool
}
