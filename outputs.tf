# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
#########################################
# General CICD Vars
#########################################

output "cicd_management_account_id" {
  value = var.cicd_management_account_id
}

output "ct_home_region" {
  value = var.ct_home_region
}

output "cloudwatch_log_group_retention" {
  value = var.cloudwatch_log_group_retention
}

#########################################
# CICD Customer VCS Variables
#########################################

output "vcs_provider" {
  value = var.vcs_provider
}

output "github_enterprise_url" {
  value = var.github_enterprise_url
}

output "infrastructure_deployment_repo_name" {
  value = var.deployment_repo_name
}

output "infrastructure_deployment_repo_branch" {
  value = var.infrastructure_deployment_repo_branch
}

#########################################
# CICD Terraform Distribution Variables
#########################################

output "terraform_version" {
  value = var.terraform_version
}

output "terraform_distribution" {
  value = var.terraform_distribution
}

output "tf_backend_secondary_region" {
  value = var.tf_backend_secondary_region
}

output "terraform_org_name" {
  value = var.terraform_org_name
}

output "terraform_api_endpoint" {
  value = var.terraform_api_endpoint
}

#########################################
# CICD VPC Variables
#########################################

output "cicd_vpc_cidr" {
  value = var.cicd_vpc_cidr
}

output "cicd_vpc_private_subnet_01_cidr" {
  value = var.cicd_vpc_private_subnet_01_cidr
}

output "cicd_vpc_private_subnet_02_cidr" {
  value = var.cicd_vpc_private_subnet_02_cidr
}

output "cicd_vpc_public_subnet_01_cidr" {
  value = var.cicd_vpc_public_subnet_01_cidr
}

output "cicd_vpc_public_subnet_02_cidr" {
  value = var.cicd_vpc_public_subnet_02_cidr
}
