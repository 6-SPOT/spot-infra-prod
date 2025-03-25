resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.priority

  dynamic "action" {
    for_each = var.actions.type == "forward" ? [1] : []
    content {
      type             = "forward"
      target_group_arn = var.actions.target_group_arn
    }
  }

  dynamic "action" {
    for_each = var.actions.type == "redirect" ? [1] : []
    content {
      type = "redirect"
      redirect {
        port        = var.actions.port
        protocol    = var.actions.protocol
        status_code = var.actions.status_code
      }
    }
  }

  dynamic "action" {
    for_each = var.actions.type == "fixed-response" ? [1] : []
    content {
      type = "fixed-response"
      fixed_response {
        content_type = var.actions.content_type
        status_code  = var.actions.status_code
        message_body = lookup(var.actions, "message_body", null)
      }
    }
  }

  dynamic "condition" {
    for_each = try(var.conditions.path_patterns, []) != [] ? [1] : []
    content {
      path_pattern {
        values = var.conditions.path_patterns
      }
    }
  }

  dynamic "condition" {
    for_each = try(var.conditions.host_headers, []) != [] ? [1] : []
    content {
      host_header {
        values = var.conditions.host_headers
      }
    }
  }
}