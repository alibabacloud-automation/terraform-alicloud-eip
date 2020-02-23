terraform-alicloud-eip
=====================================================================


本 Module 用于在阿里云创建一个[EIP实例](https://www.alibabacloud.com/help/zh/doc-detail/113775.html)并支持和 [ECS Instance](https://www.terraform.io/docs/providers/alicloud/r/instance.html)，[SLB](https://www.terraform.io/docs/providers/alicloud/r/slb.html)，[Nat Gateway](https://www.terraform.io/docs/providers/alicloud/r/nat_gateway.html) 和 [Network Interface](https://www.terraform.io/docs/providers/alicloud/r/network_interface.html) 等实例绑定。

本 Module 支持创建以下资源:

* [EIP实例](https://www.terraform.io/docs/providers/alicloud/r/eip.html)

## Terraform 版本

如果您正在使用 Terraform 0.12.

## 用法

#### 批量创建 EIP

```hcl
module "eip" {
  source = "terraform-alicloud-modules/eip/alicloud"
  region = "cn-hangzhou"

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

#### 批量创建 EIP 并将它们与多台实例绑定

**注意:** 指定了实例的时候，不需要再设置 `number_of_eips`，EIP的最终数量由实例个数决定。

```hcl
module "eip" {
  source = "terraform-alicloud-modules/eip/alicloud"
  region = "cn-hangzhou"

  create               = true
  name                 = "ecs-eip"
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

#### 批量创建 EIP 并将它们与多台新创建的实例绑定

**注意:** 指定了实例的时候，不需要再设置 `number_of_eips`，EIP的最终数量由实例个数决定。

```hcl
// Create several ECS instances
module "ecs" {
  source  = "alibaba/ecs-instance/alicloud"
  version = "~> 2.0"
  region  = "cn-hangzhou"

  number_of_instances = 3
  name                = "my-ecs-cluster"
  use_num_suffix      = true
  
  # omitted...
}

module "eip" {
  source = "terraform-alicloud-modules/eip/alicloud"
  region = "cn-hangzhou"

  create               = true
  name                 = "ecs-eip"
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

## 模板

本 Module 提供了丰富多样的模板用于创建EIP与其他资源实例进行绑定，以满足不同的使用场景，如：

* [EIP绑定多台ECS实例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/modules/associate-with-ecs)
* [EIP绑定NAT实例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/modules/associate-with-nat-gateway)
* [EIP绑定NetworkInterface实例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/modules/associate-with-network-interface)
* [EIP绑定SLB实例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/modules/associate-with-slb)

## 示例

* [EIP与多台ECS实例绑定示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/examples/associate-with-ecs)
* [EIP与NAT实例绑定示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/examples/associate-with-nat-gateway)
* [EIP与NetworkInterface实例绑定示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/examples/associate-with-network-interface)
* [EIP与SLB实例绑定示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/master/examples/associate-with-slb)


## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置.

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Zhou qilin(z17810666992@163.com), He Guimin(@xiaozhu36, heguimin36@163.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)


