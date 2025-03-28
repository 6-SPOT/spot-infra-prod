variable "name" {
  description = "프로젝트 이름"
  type        = string
}

variable "server_type" {
  description = "사용될 서버타입"
  type        = string
}

variable "deploy_role_arn" {
  description = "codeDeploy에 적용될 role_arn"
  type        = string
}

variable "target_group_name" {
  description = "배포그룹과 연결할 타깃그룹"
  type        = string
}

variable "asg_groups" {
  description = "asg그룹"
  type        = list(string)
}

#-------- 아래는 codePipeLine에서 사용하는 변수

variable "s3_revision" {
  description = "revision을 위한 s3버킷"
  type        = string
}

variable "pipe_role_arn" {
  description = "파이프라인 role"
  type        = string
}


