terraform-alicloud-eip-instance
=====================================================================


本 Module 用于在阿里云的 VPC 下创建一个[EIP实例（EIP Instance）](https://www.alibabacloud.com/help/zh/doc-detail/113775.html?spm=a2c5t.11065259.1996646101.searchclickresult.182a7228Vt6Lcw)并支持和ECS，NAT，SLB，NetworkInterface等实例绑定。

本 Module 支持创建以下资源:

* [EIP实例（EIP Instance）](https://www.terraform.io/docs/providers/alicloud/r/eip.html)

## Terraform 版本

如果您正在使用 Terraform 0.12.

## 用法

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

  number_of_computed_instances = 3
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

## 模板

本 Module 提供了丰富多样的模板用于创建EIP与其他资源实例进行绑定，以满足不同的使用场景，如：

* [EIP-ECS EIP绑定多台ECS实例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/modules/associate-with-ecs)
* [EIP-NAT EIP绑定NAT实例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/modules/associate-with-nat)
* [EIP-NetworkInterface EIP绑定NetworkInterface实例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/modules/associate-with-network-interface)
* [EIP-SLB EIP绑定SLB实例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/modules/associate-with-slb)



## 示例

* [EIP-ECS EIP与多台ECS实例绑定示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/examples/associate-with-ecs)
* [EIP-NAT EIP与NAT实例绑定示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/examples/associate-with-nat)
* [EIP-NetworkInterface EIP与NetworkInterface实例绑定示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/examples/associate-with-network_interface)
* [EIP-SLB EIP与SLB实例绑定示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eip/tree/eip/examples/associate-with-slb)

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置.

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


