##################################################
################# NAT INSTANCE ###################
##################################################

resource "aws_instance" "nat_instance" {
  count                  = var.nat_gateway_type == "INSTANCE" ? (var.singlenat == true ? 1 : length(var.publicsubnets)) : 0
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t4g.nano"
  key_name               = aws_key_pair.generated_key.key_name
  subnet_id              = aws_subnet.publicsubnets[count.index].id
  source_dest_check      = false
  vpc_security_group_ids = [aws_security_group.nat.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device {
    encrypted = true
  }
  tags = merge({ Name = format("%s-nat-instance-%s", var.project_name, count.index) }, var.default_tags)

  depends_on = [aws_internet_gateway.gw, aws_subnet.publicsubnets]

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price          = var.nat_instance_max_price
      spot_instance_type = "one-time"
    }
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y iptables-services
              systemctl stop firewalld
              systemctl disable firewalld
              systemctl enable iptables
              systemctl start iptables
              iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              iptables-save > /etc/sysconfig/iptables
              EOF
}

##################################################
################# SSH KEY ########################
##################################################

# 1. Generate a secure private key locally
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Register the public part of that key with AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "id_rsa" # This matches the name in your screenshot
  public_key = tls_private_key.main.public_key_openssh
}

# 3. (Optional) Save the private key to a local file so you can use it
resource "local_file" "ssh_key" {
  content         = tls_private_key.main.private_key_pem
  filename        = "id_rsa"
  file_permission = "0400"
}

####################################################
################### SECURITY GROUP #################
####################################################

resource "aws_security_group" "nat" {
  name        = "nat-instance-sg"
  description = "Allow traffic for NAT instance"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP/HTTPS traffic from the private subnet
  ingress {
    description = "Allow HTTP from private subnets"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = aws_subnet.privatesubnets.*.cidr_block
  }

  ingress {
    description = "Allow HTTPS from private subnets"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = aws_subnet.privatesubnets.*.cidr_block
  }

  # Allow all outbound traffic
  egress {
    description = "Allow http outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nat-sg"
  }
}