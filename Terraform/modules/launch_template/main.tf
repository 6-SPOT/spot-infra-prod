# resource "aws_launch_template" "this" {
  
# }

# resource "aws_launch_template" "example" {
#   name_prefix   = "my-app-template-"
#   image_id      = var.ami_id
#   instance_type = var.instance_type
#   key_name      = var.key_name
#   security_group_names = var.security_groups

#   user_data = base64encode(templatefile("${path.module}/user_data.sh", {
#     git_repo_url = var.git_repo_url
#   }))


#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "${var.name}-instance"
#     }
#   }
# }