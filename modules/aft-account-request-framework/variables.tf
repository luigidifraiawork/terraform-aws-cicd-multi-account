# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

variable "cicd_vpc_cidr" {
  type = string
}

variable "cicd_vpc_private_subnet_01_cidr" {
  type = string
}

variable "cicd_vpc_private_subnet_02_cidr" {
  type = string
}

variable "cicd_vpc_public_subnet_01_cidr" {
  type = string
}

variable "cicd_vpc_public_subnet_02_cidr" {
  type = string
}

variable "cicd_vpc_endpoints" {
  type = bool
}
