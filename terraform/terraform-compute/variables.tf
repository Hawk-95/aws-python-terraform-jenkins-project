variable "app_ami" {
  description = "AMI ID for application"
  type        = string
}

variable "deployment_color" {
  description = "Blue/Green deployment label"
  type        = string
  default     = "blue"
}

