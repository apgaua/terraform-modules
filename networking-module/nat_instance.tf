##################################################
################# NAT INSTANCE ###################
##################################################

resource "aws_instance" "nat_instance" {
  count                  = var.nat_gateway_type == "INSTANCE" ? (var.singlenat == true ? 1 : length(var.publicsubnets)) : 0
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t4g.nano"
  subnet_id              = aws_subnet.publicsubnets[count.index].id
  source_dest_check      = false
  vpc_security_group_ids = [aws_security_group.nat.id]

  tags = merge({ Name = format("%s-nat-instance-%s", var.project_name, count.index) }, var.default_tags)

  depends_on = [aws_internet_gateway.gw, aws_subnet.publicsubnets]

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
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nat-sg"
  }
}