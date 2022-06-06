# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
module "cicd_network" {
  providers = {
    aws = aws.cicd_management
  }
  source                          = "./modules/cicd-network"
  cicd_vpc_cidr                   = var.cicd_vpc_cidr
  cicd_vpc_private_subnet_01_cidr = var.cicd_vpc_private_subnet_01_cidr
  cicd_vpc_private_subnet_02_cidr = var.cicd_vpc_private_subnet_02_cidr
  cicd_vpc_public_subnet_01_cidr  = var.cicd_vpc_public_subnet_01_cidr
  cicd_vpc_public_subnet_02_cidr  = var.cicd_vpc_public_subnet_02_cidr
  cicd_vpc_endpoints              = var.cicd_vpc_endpoints
}

module "cicd_keys" {
  providers = {
    aws = aws.cicd_management
  }
  source = "./modules/cicd-keys"
}

module "cicd_backend" {
  providers = {
    aws.primary_region   = aws.cicd_management
    aws.secondary_region = aws.tf_backend_secondary_region
  }
  source           = "./modules/cicd-backend"
  primary_region   = var.ct_home_region
  secondary_region = var.tf_backend_secondary_region
}

module "cicd_codestar" {
  providers = {
    aws = aws.cicd_management
  }
  source                = "./modules/cicd-codestar"
  vpc_id                = module.cicd_network.cicd_vpc_id
  security_group_ids    = module.cicd_network.cicd_vpc_default_sg
  subnet_ids            = module.cicd_network.cicd_vpc_private_subnets
  github_enterprise_url = var.github_enterprise_url
  vcs_provider          = var.vcs_provider
}

module "cicd_build_projects" {
  providers = {
    aws = aws.cicd_management
  }
  source                               = "./modules/cicd-build-projects"
  cicd_framework_repo_git_ref_ssm_path = local.ssm_paths.cicd_framework_repo_git_ref_ssm_path
  cicd_framework_repo_url_ssm_path     = local.ssm_paths.cicd_framework_repo_url_ssm_path
  cicd_tf_backend_region_ssm_path      = local.ssm_paths.cicd_tf_backend_region_ssm_path
  cicd_tf_ddb_table_ssm_path           = local.ssm_paths.cicd_tf_ddb_table_ssm_path
  cicd_tf_kms_key_id_ssm_path          = local.ssm_paths.cicd_tf_kms_key_id_ssm_path
  cicd_tf_s3_bucket_ssm_path           = local.ssm_paths.cicd_tf_s3_bucket_ssm_path
  cicd_tf_version_ssm_path             = local.ssm_paths.cicd_tf_version_ssm_path
  cicd_kms_key_id                      = module.cicd_keys.cicd_kms_key_id
  cicd_kms_key_arn                     = module.cicd_keys.cicd_kms_key_arn
  cicd_vpc_id                          = module.cicd_network.cicd_vpc_id
  cicd_vpc_private_subnets             = module.cicd_network.cicd_vpc_private_subnets
  cicd_vpc_default_sg                  = module.cicd_network.cicd_vpc_default_sg
  cicd_config_backend_bucket_id        = module.cicd_backend.bucket_id
  cicd_config_backend_table_id         = module.cicd_backend.table_id
  cicd_config_backend_kms_key_id       = module.cicd_backend.kms_key_id
  terraform_distribution               = var.terraform_distribution
  cloudwatch_log_group_retention       = var.cloudwatch_log_group_retention
  global_codebuild_timeout             = var.global_codebuild_timeout
}

module "cicd_iam_roles" {
  source = "./modules/cicd-iam-roles"
  providers = {
    aws.ct_management   = aws.ct_management
    aws.cicd_management = aws.cicd_management
  }
}

module "cicd_ssm_parameters" {
  providers = {
    aws = aws.cicd_management
  }
  source                                = "./modules/cicd-ssm-parameters"
  codestar_connection_arn               = module.cicd_codestar.codestar_connection_arn
  cicd_config_backend_bucket_id         = module.cicd_backend.bucket_id
  cicd_config_backend_table_id          = module.cicd_backend.table_id
  cicd_config_backend_kms_key_id        = module.cicd_backend.kms_key_id
  cicd_administrator_role_name          = local.cicd_administrator_role_name
  cicd_execution_role_name              = local.cicd_execution_role_name
  cicd_session_name                     = local.cicd_session_name
  cicd_management_account_id            = var.cicd_management_account_id
  ct_primary_region                     = var.ct_home_region
  tf_version                            = var.terraform_version
  tf_distribution                       = var.terraform_distribution
  terraform_version                     = var.terraform_version
  vcs_provider                          = var.vcs_provider
  cicd_config_backend_primary_region    = var.ct_home_region
  cicd_framework_repo_url               = var.cicd_framework_repo_url
  cicd_framework_repo_git_ref           = local.cicd_framework_repo_git_ref
  terraform_token                       = var.terraform_token
  terraform_api_endpoint                = var.terraform_api_endpoint
  terraform_org_name                    = var.terraform_org_name
  infrastructure_deployment_repo_name   = var.infrastructure_deployment_repo_name
  infrastructure_deployment_repo_branch = var.infrastructure_deployment_repo_branch
  github_enterprise_url                 = var.github_enterprise_url
}

module "cicd_pipelines" {
  providers = {
    aws = aws.cicd_management
  }
  source            = "./modules/cicd-pipelines"
  for_each          = var.infrastructure_deployment_config
  account_id        = each.value["account_id"]
  deployment_folder = each.value["deployment_folder"]
  vcs_provider      = var.vcs_provider
  depends_on        = [module.cicd_network, module.cicd_build_projects, module.cicd_iam_roles, module.cicd_ssm_parameters]
}
