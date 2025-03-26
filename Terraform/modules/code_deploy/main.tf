resource "aws_codedeploy_app" "this" {
  name = "${var.name}-${var.server_type}-deploy"
}

resource "aws_codedeploy_deployment_group" "this" {
  deployment_group_name = "${var.name}-${var.server_type}-group"
  app_name              = aws_codedeploy_app.this.name
  service_role_arn      = var.role_arn

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  load_balancer_info {
    target_group_info {
      name = var.target_group_name
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Server"
      value = var.server_type
    }
  }
}


