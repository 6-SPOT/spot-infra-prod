variable "type" {
  description = "ALB(application) or NLB(network)"
  type        = string
}

variable "is_internal" {
  description = "ture -> internalLB, false -> externalLB"
  type        = bool
}

variable "subnet" {
  description = "subnet list"
  type = list(string)
}