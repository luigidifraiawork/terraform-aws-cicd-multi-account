# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "codestar_connection_arn" {
  name = "/aft/config/vcs/codestar-connection-arn"
}

data "aws_ssm_parameter" "infrastructure_deployment_repo_name" {
  name = "/aft/config/account-customizations/repo-name"
}

data "aws_ssm_parameter" "infrastructure_deployment_repo_branch" {
  name = "/aft/config/account-customizations/repo-branch"
}

# Lookups from aft-account-request-framework module
data "aws_kms_alias" "cicd_key" {
  name = "alias/cicd"
}

data "aws_iam_role" "cicd_codepipeline_customizations_role" {
  name = "aft-codepipeline-customizations-role"
}

data "aws_s3_bucket" "cicd_codepipeline_customizations_bucket" {
  bucket = "aft-customizations-pipeline-${data.aws_caller_identity.current.account_id}"
}
