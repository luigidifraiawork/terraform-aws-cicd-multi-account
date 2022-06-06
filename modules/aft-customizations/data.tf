# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "local_file" "aft_account_customizations_terraform" {
  filename = "${path.module}/buildspecs/aft-account-customizations-terraform.yml"
}

data "local_file" "aft_account_customizations_api_helpers" {
  filename = "${path.module}/buildspecs/aft-account-customizations-api-helpers.yml"
}
