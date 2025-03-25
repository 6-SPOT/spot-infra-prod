resource "aws_launch_template" "this" {
  name_prefix          = "${var.server_type}-template"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_group_names = var.security_groups

  iam_instance_profile {
    name = var.ec2_profile
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    git_repo_url = var.git_repo_url
  }))


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name   = "${var.name}-instance"
      Server = "${var.server_type}"
    }
  }
}
