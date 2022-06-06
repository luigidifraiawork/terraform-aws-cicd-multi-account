# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
output "cicd_codepipeline_deployment_bucket_name" {
  value = aws_s3_bucket.cicd_codepipeline_deployment_bucket.id
}

output "cicd_codepipeline_deployment_bucket_arn" {
  value = aws_s3_bucket.cicd_codepipeline_deployment_bucket.arn
}
