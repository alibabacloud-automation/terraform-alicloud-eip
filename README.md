Alicloud EIP Instance Terraform Module In VPC  
terraform-alicloud-eip
=====================================================================

English | [简体中文]()

Terraform module can create EIP instances on Alibaba Cloud and bind other resources.

These types of resources are supported:

* [EIP Instance](https://www.terraform.io/docs/providers/alicloud/r/eip.html)

## Terraform versions

For Terraform 0.12.

## Usage

```hcl
module "ecs-eip" {
  source                       = "terraform-alicloud-modules/eip/alicloud"
  create                       = "true"
  number_of_eips               = 1
  name                         = "ecs-eip"
  description                  = "An EIP associated with ECS instance."
  bandwidth                    = 5
  internet_charge_type         = "PayByTraffic"
  instance_charge_type         = "PostPaid"
  period                       = 1
  isp                          = ""
  resource_group_id            = "eip-12345678"
  tags                         = ""

  number_of_computed_instances = 2
  computed_instances = [
    {
      instance_ids  = ["i-fgh32hgh12h","i-sdh3jhrh"]
      instance_type = "EcsInstance"
      private_ips   = []
    }
  ]
  instances = [
    {
      instance_ids = ["i-g2q7r8g32h","i-bcuie3h3oi43hio4","i-bceier3"]
      instance_type = "EcsInstance"
      private_ips = ["172.16.0.1", "172.16.0.1", "172.16.0.1"]
   }
  ]
}
```

## Modules

This Module provides a variety of templates for creating EIP and binding to other resource instances to meet different usage scenarios, like:

* [EIP-ECS Instance module](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/modules/associate-with-ecs)
* [EIP-NAT Instance module](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/modules/associate-with-nat)
* [EIP-NetworkInterface Instance module](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/modules/associate-with-network-interface)
* [EIP-SLB Instance module](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/modules/associate-with-slb)


## Examples

* [EIP-ECS Instance example](https://github.com/terraform-alicloud-modules/terraform-alicloud-ecs-instance/tree/master/examples/basic)
* [EIP-NAT Instance example](https://github.com/terraform-alicloud-modules/terraform-alicloud-ecs-instance/tree/master/examples/basic)
* [EIP-NetworkInterface Instance example](https://github.com/terraform-alicloud-modules/terraform-alicloud-ecs-instance/tree/master/examples/basic)
* [EIP-SLB Instance example](https://github.com/terraform-alicloud-modules/terraform-alicloud-ecs-instance/tree/master/examples/basic)

## Notes

* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

Authors
-------
Created and maintained by Zhou qilin(z17810666992@163.com), He Guimin(@xiaozhu36, heguimin36@163.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)

