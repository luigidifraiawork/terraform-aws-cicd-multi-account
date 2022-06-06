# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
output "cicd_admin_role_arn" {
  value = aws_iam_role.cicd_admin_role.arn
}
output "cicd_exec_role_arn" {
  value = module.cicd_exec_role.arn
}
