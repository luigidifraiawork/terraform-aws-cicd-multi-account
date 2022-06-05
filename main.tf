# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
module "aft_account_request_framework" {
  providers = {
    aws               = aws.aft_management
  }
  source                                      = "./modules/aft-account-request-framework"
  aft_vpc_cidr                                = var.aft_vpc_cidr
  aft_vpc_private_subnet_01_cidr              = var.aft_vpc_private_subnet_01_cidr
  aft_vpc_private_subnet_02_cidr              = var.aft_vpc_private_subnet_02_cidr
  aft_vpc_public_subnet_01_cidr               = var.aft_vpc_public_subnet_01_cidr
  aft_vpc_public_subnet_02_cidr               = var.aft_vpc_public_subnet_02_cidr
  aft_vpc_endpoints                           = var.aft_vpc_endpoints
}

module "aft_backend" {
  providers = {
    aws.primary_region   = aws.aft_management
    aws.secondary_region = aws.tf_backend_secondary_region
  }
  source           = "./modules/aft-backend"
  primary_region   = var.ct_home_region
  secondary_region = var.tf_backend_secondary_region
}

module "aft_code_repositories" {
  providers = {
    aws = aws.aft_management
  }
  source                                          = "./modules/aft-code-repositories"
  vpc_id                                          = module.aft_account_request_framework.aft_vpc_id
  security_group_ids                              = module.aft_account_request_framework.aft_vpc_default_sg
  subnet_ids                                      = module.aft_account_request_framework.aft_vpc_private_subnets
  github_enterprise_url                           = var.github_enterprise_url
  vcs_provider                                    = var.vcs_provider
}

module "aft_customizations" {
  providers = {
    aws = aws.aft_management
  }
  source                                            = "./modules/aft-customizations"
  aft_tf_aws_customizations_module_git_ref_ssm_path = local.ssm_paths.aft_tf_aws_customizations_module_git_ref_ssm_path
  aft_tf_aws_customizations_module_url_ssm_path     = local.ssm_paths.aft_tf_aws_customizations_module_url_ssm_path
  aft_tf_backend_region_ssm_path                    = local.ssm_paths.aft_tf_backend_region_ssm_path
  aft_tf_ddb_table_ssm_path                         = local.ssm_paths.aft_tf_ddb_table_ssm_path
  aft_tf_kms_key_id_ssm_path                        = local.ssm_paths.aft_tf_kms_key_id_ssm_path
  aft_tf_s3_bucket_ssm_path                         = local.ssm_paths.aft_tf_s3_bucket_ssm_path
  aft_tf_version_ssm_path                           = local.ssm_paths.aft_tf_version_ssm_path
  aft_kms_key_id                                    = module.aft_account_request_framework.aft_kms_key_id
  aft_kms_key_arn                                   = module.aft_account_request_framework.aft_kms_key_arn
  aft_vpc_id                                        = module.aft_account_request_framework.aft_vpc_id
  aft_vpc_private_subnets                           = module.aft_account_request_framework.aft_vpc_private_subnets
  aft_vpc_default_sg                                = module.aft_account_request_framework.aft_vpc_default_sg
  aft_config_backend_bucket_id                      = module.aft_backend.bucket_id
  aft_config_backend_table_id                       = module.aft_backend.table_id
  aft_config_backend_kms_key_id                     = module.aft_backend.kms_key_id
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
  aft_config_backend_bucket_id                                = module.aft_backend.bucket_id
  aft_config_backend_table_id                                 = module.aft_backend.table_id
  aft_config_backend_kms_key_id                               = module.aft_backend.kms_key_id
  aft_administrator_role_name                                 = local.aft_administrator_role_name
  aft_execution_role_name                                     = local.aft_execution_role_name
  aft_session_name                                            = local.aft_session_name
  aft_management_account_id                                   = var.aft_management_account_id
  ct_primary_region                                           = var.ct_home_region
  tf_version                                                  = var.terraform_version
  tf_distribution                                             = var.terraform_distribution
  terraform_version                                           = var.terraform_version
  vcs_provider                                                = var.vcs_provider
  aft_config_backend_primary_region                           = var.ct_home_region
  aft_framework_repo_url                                      = var.aft_framework_repo_url
  aft_framework_repo_git_ref                                  = local.aft_framework_repo_git_ref
  terraform_token                                             = var.terraform_token
  terraform_api_endpoint                                      = var.terraform_api_endpoint
  terraform_org_name                                          = var.terraform_org_name
  account_customizations_repo_name                            = var.account_customizations_repo_name
  account_customizations_repo_branch                          = var.account_customizations_repo_branch
  github_enterprise_url                                       = var.github_enterprise_url
}
