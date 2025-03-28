resource "aws_codedeploy_app" "this" {
  name = "${var.name}-${var.server_type}-deploy"
}

resource "aws_codedeploy_deployment_group" "this" {
  deployment_group_name = "${var.name}-${var.server_type}-group"
  app_name              = aws_codedeploy_app.this.name
  service_role_arn      = var.deploy_role_arn
  autoscaling_groups    = var.asg_groups

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

########### codepipeline과 병함 ###########

resource "aws_codepipeline" "this" {
  role_arn = var.pipe_role_arn
  name     = "${var.name}-${var.server_type}-pipe"
  artifact_store {
    type     = "S3"
    location = "${var.s3_revision}"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        S3Bucket    = var.s3_revision
        S3ObjectKey = "${var.server_type}/latest.zip"
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.this.name
        DeploymentGroupName = aws_codedeploy_deployment_group.this.deployment_group_name
      }
    }
  }
}

