variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of subnet CIDRs"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = string
  default     = "ap-northeast-2a"
}

variable "name" {
  description = "Name prefix for subnets"
  type        = string
  default     = "default-subnet"
}

variable "public" {
  description = "Indicates if the subnets are public"
  type        = bool
  default     = false
}

variable "tag" {
  description = "Name prefix for subnets"
  type        = string
}