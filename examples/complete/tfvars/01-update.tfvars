# NAT
specification = "Middle"

# SLB
load_balancer_spec = "slb.s2.small"

# EIP
name          = "update-TF-Module-EIP"
description   = "update-tf-module-description"
eip_bandwidth = 10
eip_period    = 2
tags = {
  Name = "updateEIP"
}