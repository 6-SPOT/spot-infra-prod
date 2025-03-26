resource "aws_launch_template" "this" {
  name_prefix            = "${var.server_type}-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups

  update_default_version = true
  iam_instance_profile {
    name = var.ec2_profile
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    git_repo_url = var.git_repo_url
  }))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 20 
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name   = "${var.name}-instance"
      Server = "${var.server_type}"
    }
  }
}
