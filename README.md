Terraform module which creates EIPs and associate them with other resources on Alibaba Cloud    
terraform-alicloud-eip
=====================================================================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/blob/master/README-CN.md)

Terraform module can create EIP instances on Alibaba Cloud and associate them with other resources, like [ECS Instance](https://www.terraform.io/docs/providers/alicloud/r/instance.html), [SLB](https://www.terraform.io/docs/providers/alicloud/r/slb.html), [Nat Gateway](https://www.terraform.io/docs/providers/alicloud/r/nat_gateway.html) and [Network Interface](https://www.terraform.io/docs/providers/alicloud/r/network_interface.html).

These types of resources are supported:

* [EIP Instance](https://www.terraform.io/docs/providers/alicloud/r/eip.html)

## Terraform versions

For Terraform 0.12.

## Usage

#### Create several EIP instances

```hcl
module "eip" {
  source = "terraform-alicloud-modules/eip/alicloud"

  create               = true
  number_of_eips       = 5
  name                 = "my-eip"
  description          = "An EIP associated with ECS instance."
  bandwidth            = 5
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = 1
  resource_group_id    = "eip-12345678"
  tags = {
    Env      = "Private"
    Location = "foo"
  }
}
```

#### Create several EIPs and associate with other instances

**NOTE:** There is no need to specify `number_of_eips`.

```hcl
module "eip" {
  source = "terraform-alicloud-modules/eip/alicloud"

  create               = true
  name                 = "ecs-eip"
  description          = "An EIP associated with ECS instance."
  bandwidth            = 5
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = 1
  resource_group_id    = "eip-12345678"

  // Associate with ecs and slb
  instances = [
    {
      instance_ids  = ["i-g2q7r8g32h", "i-bcuie3h3oixxxx", "i-bceier3"]
      instance_type = "EcsInstance"
      private_ips   = ["172.16.0.1", "172.16.0.2", "172.16.0.3"]
    },
    {
      instance_ids  = ["slb-45678", "slb-gg8uer3"]
      instance_type = "SlbInstance"
      private_ips   = []
    }
  ]
}
```

#### Create several EIPs and associate with other computed instances

**NOTE:** There is no need to specify `number_of_eips`.

```hcl
// Create several ECS instances
module "ecs" {
  source  = "alibaba/ecs-instance/alicloud"
  version = "~> 2.0"

  number_of_instances = 3
  name                = "my-ecs-cluster"
  use_num_suffix      = true
  
  # omitted...
}

module "eip" {
  source = "terraform-alicloud-modules/eip/alicloud"

  create               = true
  name                 = "ecs-eip"
  description          = "An EIP associated with ECS instance."
  bandwidth            = 5
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = 1
  resource_group_id    = "eip-12345678"

  # The number of instances created by other modules
  number_of_computed_instances = 2
  computed_instances = [
    {
      instance_ids  = module.ecs.this_instance_id
      instance_type = "EcsInstance"
      private_ips   = []
    }
  ]
}
```

## Modules

This Module provides a variety of templates for creating EIP instances and associate them with other resource instances to meet different usage scenarios, like:

* [EIP-ECS module](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/modules/associate-with-ecs)
* [EIP-NAT module](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/modules/associate-with-nat-gateway)
* [EIP-NetworkInterface module](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/modules/associate-with-network-interface)
* [EIP-SLB module](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/modules/associate-with-slb)


## Examples

* [EIP-ECS example](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/examples/associate-with-ecs)
* [EIP-NAT example](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/examples/associate-with-nat-gateway)
* [EIP-NetworkInterface example](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/examples/associate-with-network-interface)
* [EIP-SLB example](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/examples/associate-with-slb)

## Notes
From the version v1.2.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/eip"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.1.0:

```hcl
module "eip" {
  source  = "terraform-alicloud-modules/eip/alicloud"

  version     = "1.1.0"
  region      = "cn-hangzhou"
  profile     = "Your-Profile-Name"

  create               = true
  name                 = "ecs-eip"
  description          = "An EIP associated with ECS instance."
  bandwidth            = 5
  // ...
}
```

If you want to upgrade the module to 1.2.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
   region  = "cn-hangzhou"
   profile = "Your-Profile-Name"
}
module "eip" {
  source  = "terraform-alicloud-modules/eip/alicloud"

  create               = true
  name                 = "ecs-eip"
  description          = "An EIP associated with ECS instance."
  bandwidth            = 5
  // ...
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
  alias   = "hz"
}

module "eip" {
  source  = "terraform-alicloud-modules/eip/alicloud"

  providers = {
    alicloud = alicloud.hz
  }

  create               = true
  name                 = "ecs-eip"
  description          = "An EIP associated with ECS instance."
  bandwidth            = 5
  // ...
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.

More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

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

