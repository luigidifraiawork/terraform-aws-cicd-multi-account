# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "local_file" "cicd_deployment_terraform" {
  filename = "${path.module}/buildspecs/cicd-deployment-terraform.yml"
}

data "local_file" "cicd_deployment_api_helpers" {
  filename = "${path.module}/buildspecs/cicd-deployment-api-helpers.yml"
}
