# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
locals {
  cicd_version                                     = chomp(trimspace(data.local_file.version.content))
  cicd_framework_repo_git_ref                      = var.cicd_framework_repo_git_ref == null || var.cicd_framework_repo_git_ref == "" ? local.cicd_version : var.cicd_framework_repo_git_ref
  cicd_execution_role_name                         = "AWSCICDExecution"
  cicd_administrator_role_name                     = "AWSCICDAdmin"
  cicd_session_name                                = "AWSCICD-Session"
  ssm_paths = {
    cicd_framework_repo_url_ssm_path                  = "/aft/config/aft-pipeline-code-source/repo-url"
    cicd_framework_repo_git_ref_ssm_path              = "/aft/config/aft-pipeline-code-source/repo-git-ref"
    aft_tf_s3_bucket_ssm_path                         = "/aft/config/oss-backend/bucket-id"
    aft_tf_backend_region_ssm_path                    = "/aft/config/oss-backend/primary-region"
    aft_tf_kms_key_id_ssm_path                        = "/aft/config/oss-backend/kms-key-id"
    aft_tf_ddb_table_ssm_path                         = "/aft/config/oss-backend/table-id"
    aft_tf_version_ssm_path                           = "/aft/config/terraform/version"
  }
}
