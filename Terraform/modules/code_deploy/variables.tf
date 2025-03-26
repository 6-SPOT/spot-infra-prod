variable "name" {
  description = "프로젝트 이름"
  type        = string
}

variable "server_type" {
  description = "사용될 서버타입"
  type        = string
}

variable "role_arn" {
  description = "codeDeploy에 적용될 role_arn"
  type        = string
}

variable "target_group_name" {
  description = "배포그룹과 연결할 타깃그룹"
  type        = string
}
