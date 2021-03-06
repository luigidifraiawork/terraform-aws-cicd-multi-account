# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
###################################################################
# CodePipeline IAM Resources
###################################################################

resource "aws_iam_role" "cicd_codepipeline_deployment_role" {
  name               = "cicd-codepipeline-deployment-role"
  assume_role_policy = templatefile("${path.module}/iam/trust-policies/codepipeline.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "cicd_codepipeline_deployment_policy" {
  name = "cicd-codepipeline-deployment-policy"
  role = aws_iam_role.cicd_codepipeline_deployment_role.id

  policy = templatefile("${path.module}/iam/role-policies/cicd_codepipeline_deployment_policy.tpl", {
    aws_s3_bucket_cicd_codepipeline_deployment_bucket_arn = aws_s3_bucket.cicd_codepipeline_deployment_bucket.arn
    data_aws_region_current_name                          = data.aws_region.current.name
    data_aws_caller_identity_current_account_id           = data.aws_caller_identity.current.account_id
    data_aws_kms_alias_cicd_key_target_key_arn            = var.cicd_kms_key_arn
  })
}
###################################################################
# CodeBuild IAM Resources
###################################################################

resource "aws_iam_role" "cicd_codebuild_deployment_role" {
  name               = "cicd-codebuild-deployment-role"
  assume_role_policy = templatefile("${path.module}/iam/trust-policies/codebuild.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "cicd_codebuild_deployment_policy" {
  role = aws_iam_role.cicd_codebuild_deployment_role.name

  policy = templatefile("${path.module}/iam/role-policies/cicd_codebuild_deployment_policy.tpl", {
    aws_s3_bucket_cicd_codepipeline_deployment_bucket_arn = aws_s3_bucket.cicd_codepipeline_deployment_bucket.arn
    data_aws_region_current_name                          = data.aws_region.current.name
    data_aws_caller_identity_current_account_id           = data.aws_caller_identity.current.account_id
    data_aws_kms_alias_cicd_key_target_key_arn            = var.cicd_kms_key_arn
  })
}

resource "aws_iam_role_policy" "terraform_oss_backend_codebuild_deployment_policy" {
  count = var.terraform_distribution == "oss" ? 1 : 0
  name  = "ct-cicd-codebuild-deployment-terraform-oss-backend-policy"
  role  = aws_iam_role.cicd_codebuild_deployment_role.id

  policy = templatefile("${path.module}/iam/role-policies/ct_cicd_codebuild_oss_backend_policy.tpl", {
    data_aws_region_current_name                       = data.aws_region.current.name
    data_aws_caller_identity_current_account_id        = data.aws_caller_identity.current.account_id
    data_aws_dynamo_terraform_oss_backend_table        = var.cicd_config_backend_table_id
    aws_s3_bucket_cicd_terraform_oss_backend_bucket_id = var.cicd_config_backend_bucket_id
    aws_s3_bucket_cicd_terraform_oss_kms_key_id        = var.cicd_config_backend_kms_key_id
  })
}
