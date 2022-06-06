# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
locals {
  vcs = {
    is_codecommit = lower(var.vcs_provider) == "codecommit" ? true : false
  }
}

variable "account_id" {
  type        = string
  description = "Account ID for which the pipeline is being created"
}

variable "deployment_folder" {
  type        = string
  description = "Customization folder for which the pipeline is being created"
}

variable "vcs_provider" {
  description = "Customer VCS Provider - valid inputs are codecommit, bitbucket, github, or githubenterprise"
  type        = string
}

variable "cicd_deployment_api_helpers_codebuild_name" {
  type        = string
  description = "CodeBuild Project Name"
  default     = "aft-account-customizations-api-helpers"
}

variable "cicd_deployment_terraform_codebuild_name" {
  type        = string
  description = "CodeBuild Project Name"
  default     = "aft-account-customizations-terraform"
}

