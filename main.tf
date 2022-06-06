# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
module "aft_account_request_framework" {
  providers = {
    aws               = aws.aft_management
  }
  source                                      = "./modules/aft-account-request-framework"
  cicd_vpc_cidr                               = var.cicd_vpc_cidr
  cicd_vpc_private_subnet_01_cidr             = var.cicd_vpc_private_subnet_01_cidr
  cicd_vpc_private_subnet_02_cidr             = var.cicd_vpc_private_subnet_02_cidr
  cicd_vpc_public_subnet_01_cidr              = var.cicd_vpc_public_subnet_01_cidr
  cicd_vpc_public_subnet_02_cidr              = var.cicd_vpc_public_subnet_02_cidr
  cicd_vpc_endpoints                          = var.cicd_vpc_endpoints
}

module "cicd_backend" {
  providers = {
    aws.primary_region   = aws.aft_management
    aws.secondary_region = aws.tf_backend_secondary_region
  }
  source           = "./modules/cicd-backend"
  primary_region   = var.ct_home_region
  secondary_region = var.tf_backend_secondary_region
}

module "aft_code_repositories" {
  providers = {
    aws = aws.aft_management
  }
  source                                          = "./modules/aft-code-repositories"
  vpc_id                                          = module.aft_account_request_framework.cicd_vpc_id
  security_group_ids                              = module.aft_account_request_framework.cicd_vpc_default_sg
  subnet_ids                                      = module.aft_account_request_framework.cicd_vpc_private_subnets
  github_enterprise_url                           = var.github_enterprise_url
  vcs_provider                                    = var.vcs_provider
}

module "aft_customizations" {
  providers = {
    aws = aws.aft_management
  }
  source                                            = "./modules/aft-customizations"
  cicd_framework_repo_git_ref_ssm_path              = local.ssm_paths.cicd_framework_repo_git_ref_ssm_path
  cicd_framework_repo_url_ssm_path                  = local.ssm_paths.cicd_framework_repo_url_ssm_path
  cicd_tf_backend_region_ssm_path                   = local.ssm_paths.cicd_tf_backend_region_ssm_path
  cicd_tf_ddb_table_ssm_path                        = local.ssm_paths.cicd_tf_ddb_table_ssm_path
  cicd_tf_kms_key_id_ssm_path                       = local.ssm_paths.cicd_tf_kms_key_id_ssm_path
  cicd_tf_s3_bucket_ssm_path                        = local.ssm_paths.aft_tf_s3_bucket_ssm_path
  cicd_tf_version_ssm_path                          = local.ssm_paths.cicd_tf_version_ssm_path
  cicd_kms_key_id                                   = module.aft_account_request_framework.cicd_kms_key_id
  cicd_kms_key_arn                                  = module.aft_account_request_framework.cicd_kms_key_arn
  cicd_vpc_id                                       = module.aft_account_request_framework.cicd_vpc_id
  cicd_vpc_private_subnets                          = module.aft_account_request_framework.cicd_vpc_private_subnets
  cicd_vpc_default_sg                               = module.aft_account_request_framework.cicd_vpc_default_sg
  cicd_config_backend_bucket_id                     = module.cicd_backend.bucket_id
  cicd_config_backend_table_id                      = module.cicd_backend.table_id
  cicd_config_backend_kms_key_id                    = module.cicd_backend.kms_key_id
  terraform_distribution                            = var.terraform_distribution
  cloudwatch_log_group_retention                    = var.cloudwatch_log_group_retention
  global_codebuild_timeout                          = var.global_codebuild_timeout
}

module "aft_iam_roles" {
  source = "./modules/aft-iam-roles"
  providers = {
    aws.ct_management  = aws.ct_management
    aws.aft_management = aws.aft_management
  }
}

module "aft_ssm_parameters" {
  providers = {
    aws = aws.aft_management
  }
  source                                                      = "./modules/aft-ssm-parameters"
  codestar_connection_arn                                     = module.aft_code_repositories.codestar_connection_arn
  cicd_config_backend_bucket_id                               = module.cicd_backend.bucket_id
  cicd_config_backend_table_id                                = module.cicd_backend.table_id
  cicd_config_backend_kms_key_id                              = module.cicd_backend.kms_key_id
  cicd_administrator_role_name                                = local.cicd_administrator_role_name
  cicd_execution_role_name                                    = local.cicd_execution_role_name
  cicd_session_name                                           = local.cicd_session_name
  cicd_management_account_id                                  = var.cicd_management_account_id
  ct_primary_region                                           = var.ct_home_region
  tf_version                                                  = var.terraform_version
  tf_distribution                                             = var.terraform_distribution
  terraform_version                                           = var.terraform_version
  vcs_provider                                                = var.vcs_provider
  aft_config_backend_primary_region                           = var.ct_home_region
  cicd_framework_repo_url                                     = var.cicd_framework_repo_url
  cicd_framework_repo_git_ref                                 = local.cicd_framework_repo_git_ref
  terraform_token                                             = var.terraform_token
  terraform_api_endpoint                                      = var.terraform_api_endpoint
  terraform_org_name                                          = var.terraform_org_name
  infrastructure_deployment_repo_name                         = var.infrastructure_deployment_repo_name
  infrastructure_deployment_repo_branch                       = var.infrastructure_deployment_repo_branch
  github_enterprise_url                                       = var.github_enterprise_url
}

module "aft_pipelines" {
  providers = {
    aws = aws.aft_management
  }
  source                = "./modules/aft-pipelines"
  for_each              = var.infrastructure_deployment_config
  account_id            = each.value["account_id"]
  customizations_folder = each.value["customizations_folder"]
  vcs_provider          = var.vcs_provider
  depends_on            = [module.aft_account_request_framework, module.aft_customizations, module.aft_iam_roles, module.aft_ssm_parameters]
}
