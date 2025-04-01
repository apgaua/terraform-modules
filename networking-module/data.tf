##################################################
################### AZ LISTS #####################
##################################################

data "aws_availability_zones" "azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}