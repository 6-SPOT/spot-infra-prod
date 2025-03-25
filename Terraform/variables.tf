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

variable "tg_config" {
  description = "타겟 그룹 구성 설정"
  type = map(object({
    port        = number
    protocol    = string
    type        = string
    health_path = string
  }))
}

variable "alb_config" {
  description = "ALB 관련 설정"
  type = map(object({
    type           = string
    is_internal    = bool
    enable_https   = bool
    enable_logging = bool
    logging = optional(object({
      log_prefix = string
    }))
  }))
}

variable "listener_rule_config" {
  description = "리스너 규칙을 정한것"

  type = map(object({
    priority = number

    actions = object({
      type             = string
      target_group_arn = optional(string) # 단일 TG용

      target_groups = optional(list(object({
        arn    = string
        weight = optional(number)
      }))) # 여러 TG + 가중치

      stickiness = optional(object({
        enabled  = bool
        duration = optional(number)
      }))

      status_code  = optional(string)
      content_type = optional(string)
      message_body = optional(string)
      port         = optional(string)
      protocol     = optional(string)
    })

    conditions = optional(object({
      path_patterns = optional(list(string))
      host_headers  = optional(list(string))
    }))
  }))
}

variable "ec2_profile" {
  description = "ec2 인스턴스 프로필 롤입니다."
  type        = list(string)
}

variable "codedeploy_role" {
  description = "ec2 인스턴스 프로필 롤입니다."
  type        = list(string)
}

variable "launch_template_config" {
  description = "시작 템플릿 생성"
  type = map(object({
    ami_id        = string
    instance_type = string
    key_name      = string
    git_repo_url  = string
  }))
}
