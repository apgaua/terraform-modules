## SPOT Launch Template
resource "aws_launch_template" "spot" {
  name_prefix            = format("%s-spot", var.project_name)
  image_id               = var.nodes_ami
  instance_type          = var.node_instance_type
  vpc_security_group_ids = [aws_security_group.main.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = var.cluster_spot_maxprice
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.iam_role.name
  }
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.node_volume_size
      volume_type = var.node_volume_type
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = format("%s-spot", var.project_name)
    }
  }

  user_data = base64encode(templatefile("${path.module}/templates/user-data.tpl", {
    CLUSTER_NAME = var.project_name
  }))
}
