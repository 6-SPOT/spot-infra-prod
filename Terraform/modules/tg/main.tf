resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg-${var.key}"
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = var.type

  dynamic "health_check" {
    for_each = var.health_path != null ? [1] : []
    content {
      path                = var.health_path
      matcher             = var.expect
      interval            = 30
      timeout             = 5
      healthy_threshold   = 3
      unhealthy_threshold = 2
    }
  }
}
