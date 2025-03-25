variable "name" {
  description = "project name"
  type        = string
}

variable "subnets" {
  description = "배포될 서브넷들"
  type        = list(string)
}

variable "min_size" {
  description = "최소 사이즈"
  type        = number
}

variable "max_size" {
  description = "최대 사이즈"
  type        = number
}

variable "desired_capacity" {
  description = "목표 사이즈, 없을 경우 min으로 맞춰짐"
  type        = number
}

variable "launch_template_id" {
  description = "템플릿 아이디"
  type        = string
}

variable "launch_template_version" {
  description = "템플릿 버전, 없을경우 Default로 들어감"
  type        = string
  default     = "$Default"
}

variable "target_group_arns" {
  description = "타깃그룹들. 현재 구조에서는 fe, be가 따로 동작하기에 그룹 하나씩만 넣으면된다."
  type        = list(string)
}

variable "server" {
  description = "태그표시용 이름"
  type        = string
}
