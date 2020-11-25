/**
 * ## Usage
 *
 * Creates an IAM Role for reading from any Kinesis stream in the account.
 *
 * ```hcl
 * module "kinesis_iam_role" {
 *   source = "dod-iac/kinesis-iam-role/aws"
 *
 *   name = "kinesis-iam-role"
 *   streams = ["*"]
 *   tags = {
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * Creates an IAM Role for reading from a specific Kinesis stream.
 *
 * ```hcl
 *
 * module "kinesis_iam_role" {
 *   source = "dod-iac/kinesis-iam-role/aws"
 *
 *   name = format("app-%s-kinesis-%s", var.application, var.environment)
 *   streams = [module.stream.arn]
 *   tags = {
 *     Application = var.application
 *     environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * Creates an IAM Role for allowing another AWS account to read from a specific Kinesis stream.
 *
 * ```hcl
 * data "aws_iam_policy_document" "assume_role_policy" {
 *   statement {
 *     effect  = "Allow"
 *     actions = ["sts:AssumeRole"]
 *     principals {
 *       type = "AWS"
 *       identifiers = [
 *         format("arn:%s:iam::%s:root", data.aws_partition.current.partition, var.consumer_account_id)
 *       ]
 *     }
 *   }
 * }
 *
 * module "kinesis_iam_role" {
 *   source = "dod-iac/kinesis-iam-role/aws"
 *
 *   name = format("app-%s-kinesis-%s", var.application, var.environment)
 *   assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
 *   streams = [module.stream.arn]
 *   tags = {
 *     Application = var.application
 *     environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        format("arn:%s:iam::%s:root", data.aws_partition.current.partition, data.aws_caller_identity.current.account_id)
      ]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = var.name
  assume_role_policy = length(var.assume_role_policy) > 0 ? var.assume_role_policy : data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.tags
}

data "aws_iam_policy_document" "main" {
  statement {
    sid = "ReadInputStream"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:ListShards"
    ]
    effect    = "Allow"
    resources = var.streams
  }
}

resource "aws_iam_policy" "main" {
  name   = format("%s-policy", var.name)
  path   = "/"
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}
