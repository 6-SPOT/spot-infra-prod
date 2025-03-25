variable "listener_arn" {
  description = "리스너 arn"
  type        = string
}

variable "priority" {
  description = "우선순위"
  type        = number
}


variable "actions" {
  description = "액션블록"
  type = object({
    type             = string
    target_group_arn = optional(string)
    status_code      = optional(string)
    content_type     = optional(string)
    message_body     = optional(string)
    port             = optional(string)
    protocol         = optional(string)
  })
}

variable "conditions" {
  description = "컨디션 블록"
  type = object({
    path_patterns = optional(list(string))
  })
}
