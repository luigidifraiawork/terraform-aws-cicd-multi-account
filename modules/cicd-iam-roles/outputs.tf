# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
output "aft_admin_role_arn" {
  value = aws_iam_role.aft_admin_role.arn
}
output "aft_exec_role_arn" {
  value = module.aft_exec_role.arn
}
