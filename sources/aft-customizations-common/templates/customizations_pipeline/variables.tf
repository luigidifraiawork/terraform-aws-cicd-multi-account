# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
locals {
  vcs = {
    is_codecommit = lower(data.aws_ssm_parameter.vcs_provider.value) == "codecommit" ? true : false
  }
}
variable "account_id" {
  type        = string
  description = "Account ID for which the pipeline is being created"
}

variable "aft_account_customizations_api_helpers_codebuild_name" {
  type        = string
  description = "CodeBuild Project Name"
  default     = "aft-account-customizations-api-helpers"
}

variable "aft_account_customizations_terraform_codebuild_name" {
  type        = string
  description = "CodeBuild Project Name"
  default     = "aft-account-customizations-terraform"
}

