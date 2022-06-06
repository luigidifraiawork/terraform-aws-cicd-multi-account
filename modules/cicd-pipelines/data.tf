# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "codestar_connection_arn" {
  name = "/cicd/config/vcs/codestar-connection-arn"
}

data "aws_ssm_parameter" "infrastructure_deployment_repo_name" {
  name = "/cicd/config/infrastructure-deployment/repo-name"
}

data "aws_ssm_parameter" "infrastructure_deployment_repo_branch" {
  name = "/cicd/config/infrastructure-deployment/repo-branch"
}

data "aws_kms_alias" "cicd_key" {
  name = "alias/cicd"
}

data "aws_iam_role" "cicd_codepipeline_deployment_role" {
  name = "cicd-codepipeline-deployment-role"
}

data "aws_s3_bucket" "cicd_codepipeline_deployment_bucket" {
  bucket = "cicd-deployment-pipeline-${data.aws_caller_identity.current.account_id}"
}
