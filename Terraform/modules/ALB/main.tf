resource "aws_lb" "this" {
  name                       = "${var.name}-alb"
  load_balancer_type         = var.type
  internal                   = var.is_internal
  security_groups            = var.security_groups
  subnets                    = var.subnets
  idle_timeout               = 60
  enable_deletion_protection = false


  dynamic "access_logs" {
    for_each = var.enable_logging ? [1] : []

    content {
      bucket  = var.bucket
      prefix  = var.logging.log_prefix
      enabled = true
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_lb_listener" "https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default HTTPS response"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener" "http_redirect" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
