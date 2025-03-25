variable "ami_id" {
  description = "ami 이미지 아이디"
  type        = string
}

variable "instance_type" {
  description = "만들 인스턴스"
  type        = string
}

variable "key_name" {
  description = "사용할 ssh 키"
  type        = string
}

variable "git_repo_url" {
  description = "연결할 ansible 깃주소"
  type        = string
}

variable "name" {
  description = "project name"
  type        = string
}

variable "security_groups" {
  description = "연결할 보안그룹"
  type        = list(string)
}

variable "server_type" {
  description = "서버타입 지정"
  type        = string
}

variable "ec2_profile" {
  description = "인스턴스 롤"
  type        = string
}
