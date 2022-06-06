# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
#####################################################
# CICD Infrastructure Deployment Terraform
#####################################################

resource "aws_codebuild_project" "aft_account_customizations_terraform" {
  depends_on     = [aws_cloudwatch_log_group.aft_account_customizations_terraform]
  name           = "aft-account-customizations-terraform"
  description    = "Job to apply Terraform provided by the customer account customizations repo"
  build_timeout  = tostring(var.global_codebuild_timeout)
  service_role   = aws_iam_role.cicd_codebuild_deployment_role.arn
  encryption_key = var.cicd_kms_key_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.aft_account_customizations_terraform.name
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cicd_codepipeline_deployment_bucket.id}/aft-account-customizations-terraform-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.aft_account_customizations_terraform.content
  }

  vpc_config {
    vpc_id             = var.cicd_vpc_id
    subnets            = var.cicd_vpc_private_subnets
    security_group_ids = var.cicd_vpc_default_sg
  }

}

resource "aws_cloudwatch_log_group" "aft_account_customizations_terraform" {
  name              = "/aws/codebuild/aft-account-customizations-terraform"
  retention_in_days = var.cloudwatch_log_group_retention
}

#####################################################
# CICD Infrastructure Deployment API Helpers
#####################################################

resource "aws_codebuild_project" "aft_account_customizations_api_helpers" {
  depends_on     = [aws_cloudwatch_log_group.aft_account_customizations_api_helpers]
  name           = "aft-account-customizations-api-helpers"
  description    = "Job to run API helpers provided by the customer AFT Account Module"
  build_timeout  = tostring(var.global_codebuild_timeout)
  service_role   = aws_iam_role.cicd_codebuild_deployment_role.arn
  encryption_key = var.cicd_kms_key_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.aft_account_customizations_api_helpers.name
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cicd_codepipeline_deployment_bucket.id}/aft-account-customizations-api-helpers-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.aft_account_customizations_api_helpers.content
  }

  vpc_config {
    vpc_id             = var.cicd_vpc_id
    subnets            = var.cicd_vpc_private_subnets
    security_group_ids = var.cicd_vpc_default_sg
  }

}

resource "aws_cloudwatch_log_group" "aft_account_customizations_api_helpers" {
  name              = "/aws/codebuild/aft-account-customizations-api-helpers"
  retention_in_days = var.cloudwatch_log_group_retention
}
