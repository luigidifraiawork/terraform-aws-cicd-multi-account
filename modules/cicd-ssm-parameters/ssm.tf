# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
resource "aws_ssm_parameter" "cicd_management_account_id" {
  name  = "/cicd/account/cicd-management/account-id"
  type  = "String"
  value = var.cicd_management_account_id
}

resource "aws_ssm_parameter" "ct_primary_region" {
  name  = "/cicd/config/ct-management-region"
  type  = "String"
  value = var.ct_primary_region
}

resource "aws_ssm_parameter" "tf_version" {
  name  = "/cicd/config/terraform/version"
  type  = "String"
  value = var.tf_version
}

resource "aws_ssm_parameter" "tf_distribution" {
  name  = "/aft/config/terraform/distribution"
  type  = "String"
  value = var.tf_distribution
}

resource "aws_ssm_parameter" "terraform_api_endpoint" {
  name  = "/aft/config/terraform/api-endpoint"
  type  = "String"
  value = var.terraform_api_endpoint
}

resource "aws_ssm_parameter" "terraform_token" {
  name  = "/aft/config/terraform/token"
  type  = "SecureString"
  value = var.terraform_token
}

resource "aws_ssm_parameter" "terraform_org_name" {
  name  = "/aft/config/terraform/org-name"
  type  = "String"
  value = var.terraform_org_name
}

resource "aws_ssm_parameter" "cicd_execution_role_name" {
  name  = "/cicd/resources/iam/cicd-execution-role-name"
  type  = "String"
  value = var.cicd_execution_role_name
}

resource "aws_ssm_parameter" "cicd_administrator_role_name" {
  name  = "/cicd/resources/iam/cicd-administrator-role-name"
  type  = "String"
  value = var.cicd_administrator_role_name
}

resource "aws_ssm_parameter" "cicd_session_name" {
  name  = "/cicd/resources/iam/cicd-session-name"
  type  = "String"
  value = var.cicd_session_name
}

resource "aws_ssm_parameter" "cicd_config_backend_bucket_id" {
  name  = "/cicd/config/oss-backend/bucket-id"
  type  = "String"
  value = var.cicd_config_backend_bucket_id
}

resource "aws_ssm_parameter" "cicd_config_backend_primary_region" {
  name  = "/cicd/config/oss-backend/primary-region"
  type  = "String"
  value = var.cicd_config_backend_primary_region
}

resource "aws_ssm_parameter" "cicd_config_backend_kms_key_id" {
  name  = "/cicd/config/oss-backend/kms-key-id"
  type  = "String"
  value = var.cicd_config_backend_kms_key_id
}

resource "aws_ssm_parameter" "cicd_config_backend_table_id" {
  name  = "/cicd/config/oss-backend/table-id"
  type  = "String"
  value = var.cicd_config_backend_table_id
}

resource "aws_ssm_parameter" "cicd_framework_repo_url" {
  name  = "/cicd/config/cicd-framework/repo-url"
  type  = "String"
  value = var.cicd_framework_repo_url
}

resource "aws_ssm_parameter" "cicd_framework_repo_git_ref" {
  name  = "/cicd/config/cicd-framework/repo-git-ref"
  type  = "String"
  value = var.cicd_framework_repo_git_ref
}

resource "aws_ssm_parameter" "infrastructure_deployment_repo_name" {
  name  = "/cicd/config/infrastructure-deployment/repo-name"
  type  = "String"
  value = var.infrastructure_deployment_repo_name
}

resource "aws_ssm_parameter" "infrastructure_deployment_repo_branch" {
  name  = "/cicd/config/infrastructure-deployment/repo-branch"
  type  = "String"
  value = var.infrastructure_deployment_repo_branch
}

resource "aws_ssm_parameter" "codestar_connection_arn" {
  name  = "/cicd/config/vcs/codestar-connection-arn"
  type  = "String"
  value = var.codestar_connection_arn
}