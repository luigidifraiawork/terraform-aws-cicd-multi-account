# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
variable "aft_kms_key_id" {
  type = string
}

variable "aft_kms_key_arn" {
  type = string
}

variable "aft_tf_s3_bucket_ssm_path" {
  type = string
}

variable "aft_tf_backend_region_ssm_path" {
  type = string
}

variable "aft_tf_kms_key_id_ssm_path" {
  type = string
}

variable "aft_tf_ddb_table_ssm_path" {
  type = string
}

variable "aft_tf_version_ssm_path" {
  type = string
}

variable "aft_tf_aws_customizations_module_url_ssm_path" {
  type = string
}

variable "aft_tf_aws_customizations_module_git_ref_ssm_path" {
  type = string
}

variable "cloudwatch_log_group_retention" {
  type = string
}

variable "terraform_distribution" {
  type = string
}

variable "aft_config_backend_table_id" {
  type = string
}

variable "aft_config_backend_bucket_id" {
  type = string
}

variable "aft_config_backend_kms_key_id" {
  type = string
}

variable "aft_vpc_id" {
  type = string
}

variable "aft_vpc_private_subnets" {
  type = list(string)
}

variable "aft_vpc_default_sg" {
  type = list(string)
}

variable "global_codebuild_timeout" {
  type = number
}
