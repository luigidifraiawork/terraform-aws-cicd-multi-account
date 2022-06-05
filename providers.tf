# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
provider "aws" {
  alias  = "aft_management"
  region = var.ct_home_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.aft_management_account_id}:role/AWSControlTowerExecution"
    session_name = local.aft_session_name
  }
  default_tags {
    tags = {
      managed_by = "AFT"
    }
  }
}

provider "aws" {
  alias  = "tf_backend_secondary_region"
  region = var.tf_backend_secondary_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.aft_management_account_id}:role/AWSControlTowerExecution"
    session_name = local.aft_session_name
  }
  default_tags {
    tags = {
      managed_by = "AFT"
    }
  }
}
