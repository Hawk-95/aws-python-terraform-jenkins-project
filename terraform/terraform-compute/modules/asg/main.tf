resource "aws_autoscaling_group" "app_asg" {
  name                = "app-asg-${var.deployment_color}"
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 60
    }

    triggers = ["launch_template"]
  }

  tag {
    key                 = "Deployment_Color"
    value               = var.deployment_color
    propagate_at_launch = true
  }
}

