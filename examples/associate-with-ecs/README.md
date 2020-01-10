# EIP-ECS Instance example

The configuration in this directory will create multiple ECS instances and associate them with EIP

Data sources are used to discover existing vpc, vswitch and security groups.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Outputs

| Name | Description |
|------|-------------|
| this\_eip\_id | The EIP ID |
| this\_eip\_name | The name of the EIP instance |
| this\_eip\_internet_charge_type | Internet charge type of the EIP |
| this\_eip\_bandwidth | The elastic public network bandwidth |
| this\_eip\_isp | The line type of the Elastic IP instance |
| this\_eip\_status | The EIP current status |
| this\_eip\_address | The elastic ip address |
| this\_eip\_tags | A mapping of tags to assign to the resource |
| this\_eip\_association_instance_id | The ECS instance ID associated with the EIP |
| this\eip\_association_instance_type | The type of cloud product that the eip instance to bind |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->