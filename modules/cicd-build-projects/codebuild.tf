# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
#####################################################
# CICD Infrastructure Deployment Terraform
#####################################################

resource "aws_codebuild_project" "cicd_deployment_terraform" {
  depends_on     = [aws_cloudwatch_log_group.cicd_deployment_terraform]
  name           = "cicd-deployment-terraform"
  description    = "Job to apply Terraform provided by the customer deployment repo"
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
      group_name = aws_cloudwatch_log_group.cicd_deployment_terraform.name
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cicd_codepipeline_deployment_bucket.id}/cicd-deployment-terraform-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.cicd_deployment_terraform.content
  }

  vpc_config {
    vpc_id             = var.cicd_vpc_id
    subnets            = var.cicd_vpc_private_subnets
    security_group_ids = var.cicd_vpc_default_sg
  }

}

resource "aws_cloudwatch_log_group" "cicd_deployment_terraform" {
  name              = "/aws/codebuild/cicd-deployment-terraform"
  retention_in_days = var.cloudwatch_log_group_retention
}

#####################################################
# CICD Infrastructure Deployment API Helpers
#####################################################

resource "aws_codebuild_project" "cicd_deployment_api_helpers" {
  depends_on     = [aws_cloudwatch_log_group.cicd_deployment_api_helpers]
  name           = "cicd-deployment-api-helpers"
  description    = "Job to run API helpers provided by the customer deployment repo"
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
      group_name = aws_cloudwatch_log_group.cicd_deployment_api_helpers.name
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cicd_codepipeline_deployment_bucket.id}/cicd-deployment-api-helpers-logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.local_file.cicd_deployment_api_helpers.content
  }

  vpc_config {
    vpc_id             = var.cicd_vpc_id
    subnets            = var.cicd_vpc_private_subnets
    security_group_ids = var.cicd_vpc_default_sg
  }

}

resource "aws_cloudwatch_log_group" "cicd_deployment_api_helpers" {
  name              = "/aws/codebuild/cicd-deployment-api-helpers"
  retention_in_days = var.cloudwatch_log_group_retention
}
