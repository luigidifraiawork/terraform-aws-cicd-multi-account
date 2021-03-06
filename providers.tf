# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
provider "aws" {
  alias  = "ct_management"
  region = var.ct_home_region
  # The default profile or environment variables should authenticate to the Control Tower Management Account as Administrator
  default_tags {
    tags = {
      managed_by = "CICD"
    }
  }
}

provider "aws" {
  alias  = "cicd_management"
  region = var.ct_home_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.cicd_management_account_id}:role/AWSControlTowerExecution"
    session_name = local.cicd_session_name
  }
  default_tags {
    tags = {
      managed_by = "CICD"
    }
  }
}

provider "aws" {
  alias  = "tf_backend_secondary_region"
  region = var.tf_backend_secondary_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.cicd_management_account_id}:role/AWSControlTowerExecution"
    session_name = local.cicd_session_name
  }
  default_tags {
    tags = {
      managed_by = "CICD"
    }
  }
}
