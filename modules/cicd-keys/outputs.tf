# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
output "cicd_kms_key_arn" {
  description = "Arn for the CICD CMK Key"
  value       = aws_kms_key.cicd.arn
}

output "cicd_kms_key_id" {
  description = "ID for the CICD CMK Key"
  value       = aws_kms_key.cicd.id
}
