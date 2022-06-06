# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
data "aws_caller_identity" "cicd_management" {
  provider = aws.cicd_management
}

resource "aws_iam_role" "cicd_admin_role" {
  provider = aws.cicd_management
  name     = "AWSCICDAdmin"
  assume_role_policy = templatefile("${path.module}/iam/aft_admin_role_trust_policy.tpl",
    {
      aft_account_id = data.aws_caller_identity.cicd_management.account_id
    }
  )
}

resource "aws_iam_role_policy" "cicd_admin_role" {
  provider = aws.cicd_management
  name     = "aft_admin_role_policy"
  role     = aws_iam_role.cicd_admin_role.id

  policy = file("${path.module}/iam/aft_admin_role_policy.tpl")
}

module "cicd_exec_role" {
  source = "./admin-role"
  providers = {
    aws = aws.cicd_management
  }
  trusted_entity = aws_iam_role.cicd_admin_role.arn
}

module "cicd_service_role" {
  source = "./service-role"
  providers = {
    aws = aws.cicd_management
  }
  trusted_entity = aws_iam_role.cicd_admin_role.arn
}
