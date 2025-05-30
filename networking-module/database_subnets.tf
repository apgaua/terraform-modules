locals {
  nacl = flatten([
    for acl in var.database_nacl_rules : [
      for index, subnet in var.databasesubnets : {
        rule_number = acl.rule_start_number + index
        rule_action = acl.rule_action
        protocol    = acl.protocol
        from_port   = acl.from_port
        to_port     = acl.to_port
        cidr_block  = subnet
      }
    ]
  ])
}

##################################################
##################### SUBNET #####################
##################################################

resource "aws_subnet" "dbsubnets" {
  count             = length(var.databasesubnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.databasesubnets[count.index]
  availability_zone = data.aws_availability_zones.azones.names[count.index]
  tags = merge(
    {
      Name = format("database-%s-%s", var.project_name, data.aws_availability_zones.azones.names[count.index])
    },
    var.default_tags
  )
}

##################################################
################## NETWORK ACL ###################
##################################################

resource "aws_network_acl" "database" {
  vpc_id = aws_vpc.main.id

  egress {
    rule_no    = 200
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name = format("database-%s", var.project_name)
    },
    var.default_tags
  )
}

##################################################
############ NETWORK ACL ASSOCIATION #############
##################################################

resource "aws_network_acl_association" "database" {
  count = length(var.databasesubnets)

  network_acl_id = aws_network_acl.database.id
  subnet_id      = aws_subnet.dbsubnets[count.index].id
}

##################################################
############### NETWORK ACL RULES ################
##################################################

resource "aws_network_acl_rule" "ingress" {
  count = length(local.nacl)

  network_acl_id = aws_network_acl.database.id
  rule_number    = local.nacl[count.index].rule_number
  egress         = false

  rule_action = local.nacl[count.index].rule_action
  protocol    = local.nacl[count.index].protocol
  cidr_block  = local.nacl[count.index].cidr_block
  from_port   = local.nacl[count.index].from_port
  to_port     = local.nacl[count.index].to_port
}
