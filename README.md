<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

Creates an IAM Role for reading from any Kinesis stream in the account.

```hcl
module "kinesis_iam_role" {
  source = "dod-iac/kinesis-iam-role/aws"

  name = "kinesis-iam-role"
  streams = ["*"]
  tags = {
    Automation  = "Terraform"
  }
}
```

Creates an IAM Role for reading from a specific Kinesis stream.

```hcl

module "kinesis_iam_role" {
  source = "dod-iac/kinesis-iam-role/aws"

  name = format("app-%s-kinesis-%s", var.application, var.environment)
  streams = [module.stream.arn]
  tags = {
    Application = var.application
    environment = var.environment
    Automation  = "Terraform"
  }
}
```

Creates an IAM Role for allowing another AWS account to read from a specific Kinesis stream.

```hcl
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        format("arn:%s:iam::%s:root", data.aws_partition.current.partition, var.consumer_account_id)
      ]
    }
  }
}

module "kinesis_iam_role" {
  source = "dod-iac/kinesis-iam-role/aws"

  name = format("app-%s-kinesis-%s", var.application, var.environment)
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  streams = [module.stream.arn]
  tags = {
    Application = var.application
    environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_list_streams"></a> [allow\_list\_streams](#input\_allow\_list\_streams) | Allow IAM role to list Kinesis streams in the account. | `bool` | n/a | yes |
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | The assume role policy for the AWS IAM role.  If blank, allows any principal in the account to assume the role. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the AWS IAM role. | `string` | n/a | yes |
| <a name="input_streams"></a> [streams](#input\_streams) | The ARNs of the  streams the role is allowed to read from.  Use ["*"] to allow all streams. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the AWS IAM role. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the AWS IAM Role. |
| <a name="output_name"></a> [name](#output\_name) | The name of the AWS IAM Role. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
