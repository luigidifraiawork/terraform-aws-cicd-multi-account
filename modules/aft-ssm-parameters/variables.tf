# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
variable "vcs_provider" {
  type = string
}

variable "aft_management_account_id" {
  type = string
}

variable "ct_primary_region" {
  type = string
}

variable "tf_version" {
  type = string
}

variable "tf_distribution" {
  type = string
}

variable "terraform_api_endpoint" {
  type = string
}

variable "terraform_token" {
  type      = string
  sensitive = true
}

variable "terraform_org_name" {
  type = string
}

variable "aft_config_backend_bucket_id" {
  type = string
}

variable "aft_config_backend_primary_region" {
  type = string
}

variable "aft_config_backend_kms_key_id" {
  type = string
}

variable "aft_config_backend_table_id" {
  type = string
}

variable "aft_framework_repo_url" {
  type = string
}

variable "aft_framework_repo_git_ref" {
  type = string
}

variable "terraform_version" {
  type = string
}

variable "account_customizations_repo_name" {
  type = string
}

variable "account_customizations_repo_branch" {
  type = string
}

variable "codestar_connection_arn" {
  type = string
}

variable "github_enterprise_url" {
  type = string
}
