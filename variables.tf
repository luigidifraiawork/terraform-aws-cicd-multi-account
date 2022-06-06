# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
#########################################
# General CICD Vars
#########################################

variable "cicd_framework_repo_url" {
  description = "Git repo URL where the CICD framework should be sourced from"
  default     = "https://github.com/luigidifraiawork/terraform-aws-cicd-multi-account.git"
  type        = string
  validation {
    condition     = length(var.cicd_framework_repo_url) > 0
    error_message = "Variable var: cicd_framework_repo_url cannot be empty."
  }
}

variable "cicd_framework_repo_git_ref" {
  description = "Git branch from which the CICD framework should be sourced"
  default     = null
  type        = string
}

variable "cicd_management_account_id" {
  description = "CICD Management Account ID"
  type        = string
  validation {
    condition     = can(regex("^\\d{12}$", var.cicd_management_account_id))
    error_message = "Variable var: cicd_management_account_id is not valid."
  }
}

variable "ct_home_region" {
  description = "The region from which this module will be executed. This MUST be the same region as Control Tower is deployed."
  type        = string
  validation {
    condition     = can(regex("(us(-gov)?|ap|ca|cn|eu|sa)-(central|(north|south)?(east|west)?)-\\d", var.ct_home_region))
    error_message = "Variable var: region is not valid."
  }
}

variable "cloudwatch_log_group_retention" {
  description = "Amount of days to keep CloudWatch Log Groups for Lambda functions. 0 = Never Expire"
  type        = string
  default     = "0"
  validation {
    condition     = contains(["1", "3", "5", "7", "14", "30", "60", "90", "120", "150", "180", "365", "400", "545", "731", "1827", "3653", "0"], var.cloudwatch_log_group_retention)
    error_message = "Valid values for var: cloudwatch_log_group_retention are (1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0)."
  }
}

variable "cicd_vpc_endpoints" {
  type        = bool
  description = "Flag turning VPC endpoints on/off for CICD VPC"
  default     = true
  validation {
    condition     = contains([true, false], var.cicd_vpc_endpoints)
    error_message = "Valid values for var: cicd_vpc_endpoints are (true, false)."
  }
}

variable "global_codebuild_timeout" {
  type        = number
  description = "Codebuild build timeout"
  default     = 60
  validation {
    condition = (
      var.global_codebuild_timeout >= 5 &&
      var.global_codebuild_timeout <= 480
    )
    error_message = "Codebuild build timeout must be between 5 and 480 minutes."
  }
}

#########################################
# CICD Customer VCS Variables
#########################################

variable "vcs_provider" {
  description = "Customer VCS Provider - valid inputs are codecommit, bitbucket, github, or githubenterprise"
  type        = string
  default     = "codecommit"
  validation {
    condition     = contains(["codecommit", "bitbucket", "github", "githubenterprise"], var.vcs_provider)
    error_message = "Valid values for var: vcs_provider are (codecommit, bitbucket, github, githubenterprise)."
  }
}

variable "github_enterprise_url" {
  description = "GitHub enterprise URL, if GitHub Enterprise is being used"
  type        = string
  default     = "null"
}

variable "deployment_repo_name" {
  description = "Repository name for the deployment files. For non-CodeCommit repos, name should be in the format of Org/Repo"
  type        = string
  default     = "aft-account-customizations"
  validation {
    condition     = length(var.deployment_repo_name) > 0
    error_message = "Variable var: infrastructure_deployment_repo_name cannot be empty."
  }
}

variable "infrastructure_deployment_repo_branch" {
  description = "Branch to source deployment repo from"
  type        = string
  default     = "main"
  validation {
    condition     = length(var.infrastructure_deployment_repo_branch) > 0
    error_message = "Variable var: infrastructure_deployment_repo_branch cannot be empty."
  }
}

#########################################
# CICD Per-Account Deployment Variables
#########################################

variable "infrastructure_deployment_config" {
  description = "Map of objects for per account infrastructure deployment"
  type = map(object({
    account_id        = string
    deployment_folder = string
  }))
}

#########################################
# CICD Terraform Distribution Variables
#########################################

variable "terraform_version" {
  description = "Terraform version being used for CICD"
  type        = string
  default     = "0.15.5"
  validation {
    condition     = can(regex("\\bv?\\d+(\\.\\d+)+[\\-\\w]*\\b", var.terraform_version))
    error_message = "Invalid value for var: terraform_version."
  }
}

variable "terraform_distribution" {
  description = "Terraform distribution being used for CICD - valid values are oss, tfc, or tfe"
  type        = string
  default     = "oss"
  validation {
    condition     = contains(["oss", "tfc", "tfe"], var.terraform_distribution)
    error_message = "Valid values for var: terraform_distribution are (oss, tfc, tfe)."
  }
}

variable "tf_backend_secondary_region" {
  type        = string
  description = "CICD creates a backend for state tracking for its own state as well as OSS cases. The backend's primary region is the same as the CICD region, but this defines the secondary region to replicate to."
  validation {
    condition     = can(regex("(us(-gov)?|ap|ca|cn|eu|sa)-(central|(north|south)?(east|west)?)-\\d", var.tf_backend_secondary_region))
    error_message = "Variable var: tf_backend_secondary_region is not valid."
  }
}

# Non-OSS Variables
variable "terraform_token" {
  type        = string
  description = "Terraform token for Cloud or Enterprise"
  default     = "null"
  sensitive   = true
  validation {
    condition     = length(var.terraform_token) > 0
    error_message = "Variable var: terraform_token cannot be empty."
  }
}

variable "terraform_org_name" {
  type        = string
  description = "Organization name for Terraform Cloud or Enterprise"
  default     = "null"
  validation {
    condition     = length(var.terraform_org_name) > 0
    error_message = "Variable var: terraform_org_name cannot be empty."
  }
}

variable "terraform_api_endpoint" {
  description = "API Endpoint for Terraform. Must be in the format of https://xxx.xxx."
  type        = string
  default     = "https://app.terraform.io/api/v2/"
  validation {
    condition     = length(var.terraform_api_endpoint) > 0
    error_message = "Variable var: terraform_api_endpoint cannot be empty."
  }
}

#########################################
# CICD VPC Variables
#########################################

variable "cicd_vpc_cidr" {
  type        = string
  description = "CIDR Block to allocate to the CICD VPC"
  default     = "192.168.0.0/22"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.cicd_vpc_cidr))
    error_message = "Variable var: cicd_vpc_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}

variable "cicd_vpc_private_subnet_01_cidr" {
  type        = string
  description = "CIDR Block to allocate to the Private Subnet 01"
  default     = "192.168.0.0/24"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.cicd_vpc_private_subnet_01_cidr))
    error_message = "Variable var: cicd_vpc_private_subnet_01_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}

variable "cicd_vpc_private_subnet_02_cidr" {
  type        = string
  description = "CIDR Block to allocate to the Private Subnet 02"
  default     = "192.168.1.0/24"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.cicd_vpc_private_subnet_02_cidr))
    error_message = "Variable var: cicd_vpc_private_subnet_02_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}

variable "cicd_vpc_public_subnet_01_cidr" {
  type        = string
  description = "CIDR Block to allocate to the Public Subnet 01"
  default     = "192.168.2.0/25"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.cicd_vpc_public_subnet_01_cidr))
    error_message = "Variable var: cicd_vpc_public_subnet_01_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}

variable "cicd_vpc_public_subnet_02_cidr" {
  type        = string
  description = "CIDR Block to allocate to the Public Subnet 02"
  default     = "192.168.2.128/25"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.cicd_vpc_public_subnet_02_cidr))
    error_message = "Variable var: cicd_vpc_public_subnet_02_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}
