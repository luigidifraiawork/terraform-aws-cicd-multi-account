# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
output "aft_codepipeline_customizations_bucket_name" {
  value = aws_s3_bucket.aft_codepipeline_customizations_bucket.id
}

output "aft_codepipeline_customizations_bucket_arn" {
  value = aws_s3_bucket.aft_codepipeline_customizations_bucket.arn
}
