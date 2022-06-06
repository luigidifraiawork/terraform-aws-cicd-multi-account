# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
resource "aws_kms_key" "cicd" {
  description         = "CICD KMS key"
  enable_key_rotation = "true"
}
resource "aws_kms_alias" "cicd" {
  name          = "alias/cicd"
  target_key_id = aws_kms_key.cicd.key_id
}
