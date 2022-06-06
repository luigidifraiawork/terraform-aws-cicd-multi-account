# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
resource "aws_codepipeline" "cicd_codecommit_deployment_codepipeline" {
  count    = local.vcs.is_codecommit ? 1 : 0
  name     = "${var.account_id}-deployment-pipeline"
  role_arn = data.aws_iam_role.cicd_codepipeline_deployment_role.arn

  artifact_store {
    location = data.aws_s3_bucket.cicd_codepipeline_deployment_bucket.id
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.cicd_key.arn
      type = "KMS"
    }
  }

  ##############################################################
  # Source
  ##############################################################
  stage {
    name = "Source"

    action {
      name             = "cicd-deployment"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source-cicd-deployment"]

      configuration = {
        RepositoryName       = data.aws_ssm_parameter.infrastructure_deployment_repo_name.value
        BranchName           = data.aws_ssm_parameter.infrastructure_deployment_repo_branch.value
        PollForSourceChanges = false
      }
    }
  }

  ##############################################################
  # Deploy
  ##############################################################

  stage {
    name = "Deploy"

    action {
      name            = "Pre-API-Helpers"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source-cicd-deployment"]
      version         = "1"
      run_order       = "1"
      configuration = {
        ProjectName = var.cicd_deployment_api_helpers_codebuild_name
        EnvironmentVariables = jsonencode([
          {
            name  = "VENDED_ACCOUNT_ID",
            value = var.account_id,
            type  = "PLAINTEXT"
          },
          {
            name  = "CUSTOMIZATION",
            value = var.deployment_folder,
            type  = "PLAINTEXT"
          },
          {
            name  = "SHELL_SCRIPT",
            value = "pre-api-helpers.sh",
            type  = "PLAINTEXT"
          }
        ])
      }
    }

    action {
      name            = "Apply-Terraform"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source-cicd-deployment"]
      version         = "1"
      run_order       = "2"
      configuration = {
        ProjectName = var.cicd_deployment_terraform_codebuild_name
        EnvironmentVariables = jsonencode([
          {
            name  = "VENDED_ACCOUNT_ID",
            value = var.account_id,
            type  = "PLAINTEXT"
          },
          {
            name  = "CUSTOMIZATION",
            value = var.deployment_folder,
            type  = "PLAINTEXT"
          }
        ])
      }
    }

    action {
      name            = "Post-API-Helpers"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source-cicd-deployment"]
      version         = "1"
      run_order       = "3"
      configuration = {
        ProjectName = var.cicd_deployment_api_helpers_codebuild_name
        EnvironmentVariables = jsonencode([
          {
            name  = "VENDED_ACCOUNT_ID",
            value = var.account_id,
            type  = "PLAINTEXT"
          },
          {
            name  = "CUSTOMIZATION",
            value = var.deployment_folder,
            type  = "PLAINTEXT"
          },
          {
            name  = "SHELL_SCRIPT",
            value = "post-api-helpers.sh",
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }
}

resource "aws_codepipeline" "cicd_codestar_deployment_codepipeline" {
  count    = local.vcs.is_codecommit ? 0 : 1
  name     = "${var.account_id}-deployment-pipeline"
  role_arn = data.aws_iam_role.cicd_codepipeline_deployment_role.arn

  artifact_store {
    location = data.aws_s3_bucket.cicd_codepipeline_deployment_bucket.id
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.cicd_key.arn
      type = "KMS"
    }
  }

  ##############################################################
  # Source
  ##############################################################
  stage {
    name = "Source"

    action {
      name             = "cicd-deployment"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source-cicd-deployment"]

      configuration = {
        ConnectionArn        = data.aws_ssm_parameter.codestar_connection_arn.value
        FullRepositoryId     = data.aws_ssm_parameter.infrastructure_deployment_repo_name.value
        BranchName           = data.aws_ssm_parameter.infrastructure_deployment_repo_branch.value
        DetectChanges        = false
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  ##############################################################
  # Deploy
  ##############################################################

  stage {
    name = "Deploy"

    action {
      name            = "Pre-API-Helpers"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source-cicd-deployment"]
      version         = "1"
      run_order       = "1"
      configuration = {
        ProjectName = var.cicd_deployment_api_helpers_codebuild_name
        EnvironmentVariables = jsonencode([
          {
            name  = "VENDED_ACCOUNT_ID",
            value = var.account_id,
            type  = "PLAINTEXT"
          },
          {
            name  = "CUSTOMIZATION",
            value = var.deployment_folder,
            type  = "PLAINTEXT"
          },
          {
            name  = "SHELL_SCRIPT",
            value = "pre-api-helpers.sh",
            type  = "PLAINTEXT"
          }
        ])
      }
    }

    action {
      name            = "Apply-Terraform"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source-cicd-deployment"]
      version         = "1"
      run_order       = "2"
      configuration = {
        ProjectName = var.cicd_deployment_terraform_codebuild_name
        EnvironmentVariables = jsonencode([
          {
            name  = "VENDED_ACCOUNT_ID",
            value = var.account_id,
            type  = "PLAINTEXT"
          },
          {
            name  = "CUSTOMIZATION",
            value = var.deployment_folder,
            type  = "PLAINTEXT"
          }
        ])
      }
    }

    action {
      name            = "Post-API-Helpers"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source-cicd-deployment"]
      version         = "1"
      run_order       = "3"
      configuration = {
        ProjectName = var.cicd_deployment_api_helpers_codebuild_name
        EnvironmentVariables = jsonencode([
          {
            name  = "VENDED_ACCOUNT_ID",
            value = var.account_id,
            type  = "PLAINTEXT"
          },
          {
            name  = "CUSTOMIZATION",
            value = var.deployment_folder,
            type  = "PLAINTEXT"
          },
          {
            name  = "SHELL_SCRIPT",
            value = "post-api-helpers.sh",
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }
}
