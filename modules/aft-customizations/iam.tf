# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
###################################################################
# CodePipeline IAM Resources
###################################################################

resource "aws_iam_role" "aft_codepipeline_customizations_role" {
  name               = "aft-codepipeline-customizations-role"
  assume_role_policy = templatefile("${path.module}/iam/trust-policies/codepipeline.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "aft_codepipeline_customizations_policy" {
  name = "aft-codepipeline-customizations-policy"
  role = aws_iam_role.aft_codepipeline_customizations_role.id

  policy = templatefile("${path.module}/iam/role-policies/aft_codepipeline_customizations_policy.tpl", {
    aws_s3_bucket_aft_codepipeline_customizations_bucket_arn = aws_s3_bucket.aft_codepipeline_customizations_bucket.arn
    data_aws_region_current_name                             = data.aws_region.current.name
    data_aws_caller_identity_current_account_id              = data.aws_caller_identity.current.account_id
    data_aws_kms_alias_aft_key_target_key_arn                = var.cicd_kms_key_arn
  })
}
###################################################################
# CodeBuild IAM Resources
###################################################################

resource "aws_iam_role" "aft_codebuild_customizations_role" {
  name               = "aft-codebuild-customizations-role"
  assume_role_policy = templatefile("${path.module}/iam/trust-policies/codebuild.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "aft_codebuild_customizations_policy" {
  role = aws_iam_role.aft_codebuild_customizations_role.name

  policy = templatefile("${path.module}/iam/role-policies/aft_codebuild_customizations_policy.tpl", {
    aws_s3_bucket_aft_codepipeline_customizations_bucket_arn = aws_s3_bucket.aft_codepipeline_customizations_bucket.arn
    data_aws_region_current_name                             = data.aws_region.current.name
    data_aws_caller_identity_current_account_id              = data.aws_caller_identity.current.account_id
    data_aws_kms_alias_aft_key_target_key_arn                = var.cicd_kms_key_arn
    #data_aws_dynamo_account_metadata_table                   = var.request_metadata_table_name
  })
}

resource "aws_iam_role_policy" "terraform_oss_backend_codebuild_customizations_policy" {
  count = var.terraform_distribution == "oss" ? 1 : 0
  name  = "ct-aft-codebuild-customizations-terraform-oss-backend-policy"
  role  = aws_iam_role.aft_codebuild_customizations_role.id

  policy = templatefile("${path.module}/iam/role-policies/ct_aft_codebuild_oss_backend_policy.tpl", {
    data_aws_region_current_name                      = data.aws_region.current.name
    data_aws_caller_identity_current_account_id       = data.aws_caller_identity.current.account_id
    data_aws_dynamo_terraform_oss_backend_table       = var.cicd_config_backend_table_id
    aws_s3_bucket_aft_terraform_oss_backend_bucket_id = var.cicd_config_backend_bucket_id
    aws_s3_bucket_aft_terraform_oss_kms_key_id        = var.cicd_config_backend_kms_key_id
  })
}
