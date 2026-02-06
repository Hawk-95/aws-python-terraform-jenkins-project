variable "launch_template_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "deployment_color" {
  type = string
}

