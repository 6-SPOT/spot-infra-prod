resource "aws_autoscaling_group" "this" {
  name                = "${var.name}-${var.server}-asg"
  vpc_zone_identifier = var.subnets
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  force_delete        = true

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  target_group_arns = var.target_group_arns

  health_check_type         = "ELB"
  health_check_grace_period = 60

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupTerminatingInstances",
    "GroupStandbyInstances"
  ]

  termination_policies = ["OldestInstance"]

  lifecycle {
    create_before_destroy = true
  }

  initial_lifecycle_hook {
    name                 = "${var.name}-${var.server}-launch-hook"
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 180
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-instance"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 60
    }
  }
}
