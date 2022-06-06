# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
resource "aws_s3_bucket" "cicd_codepipeline_deployment_bucket" {
  bucket = "cicd-deployment-pipeline-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "cicd_codepipeline_deployment_bucket_versioning" {
  bucket = aws_s3_bucket.cicd_codepipeline_deployment_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cicd_codepipeline_deployment_bucket_encryption" {
  bucket = aws_s3_bucket.cicd_codepipeline_deployment_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.cicd_kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "cicd_codepipeline_deployment_bucket_acl" {
  bucket = aws_s3_bucket.cicd_codepipeline_deployment_bucket.id
  acl    = "private"
}
