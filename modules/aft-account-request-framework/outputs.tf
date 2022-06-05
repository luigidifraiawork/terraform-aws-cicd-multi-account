# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
output "aft_kms_key_arn" {
  description = "Arn for the AFT CMK Key"
  value       = aws_kms_key.aft.arn
}

output "aft_kms_key_id" {
  description = "ID for the AFT CMK Key"
  value       = aws_kms_key.aft.id
}

#########################################
# VPC Outputs
#########################################

output "aft_vpc_id" {
  value = aws_vpc.aft_vpc.id
}

output "aft_vpc_public_subnets" {
  value = tolist([aws_subnet.aft_vpc_public_subnet_01.id, aws_subnet.aft_vpc_public_subnet_02.id])
}

output "aft_vpc_private_subnets" {
  value = tolist([aws_subnet.aft_vpc_private_subnet_01.id, aws_subnet.aft_vpc_private_subnet_02.id])
}

output "aft_vpc_default_sg" {
  value = tolist([aws_security_group.aft_vpc_default_sg.id])
}
