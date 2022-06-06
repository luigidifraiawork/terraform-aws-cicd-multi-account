#!/bin/bash
# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

# Default flags to false
USER_DEFINED_ACCOUNT=false

# Ensure at option was specified
if [ $# -eq 0 ]; then
  echo "";
  echo "No options have been provided.";
  exit;
fi

# Parse options and set flags
while [ ! $# -eq 0 ]
do
  case "$1" in
    --account-id)
      USER_DEFINED_ACCOUNT=true
      USER_DEFINED_ACCOUNT_ID=$2
      echo $ACCOUNT_ID
      ;;
    --help)
      echo ""
      echo "creds.sh creates an AWS CLI credential file leveraging the AWSCICDExecution role to use with API Helpers for the specified account"
      echo ""
      echo "** creds.sh should be run from the CI/CD Management account with a role that can assume the AWSCICDAdmin role"
      echo ""
      echo "usage: creds.sh [--account account_id]"
      echo ""
      echo "--account-id - Create a default credential profile for the given account number.   Profile name: default"
      exit
      ;;
  esac
  shift
done

# Remove Credentials file, if exists
mkdir -p ~/.aws
rm -f ~/.aws/credentials

# Lookup SSM Parameters
AFT_MGMT_ROLE=$(aws ssm get-parameter --name /aft/resources/iam/aft-administrator-role-name | jq --raw-output ".Parameter.Value")
AFT_EXECUTION_ROLE=$(aws ssm get-parameter --name /aft/resources/iam/aft-execution-role-name | jq --raw-output ".Parameter.Value")
ROLE_SESSION_NAME=$(aws ssm get-parameter --name /aft/resources/iam/aft-session-name | jq --raw-output ".Parameter.Value")
AFT_MGMT_ACCOUNT=$(aws ssm get-parameter --name /aft/account/aft-management/account-id | jq --raw-output ".Parameter.Value")

if $USER_DEFINED_ACCOUNT; then
  # Assume AWSCICDAdmin in AFT Management account
  echo "Assuming ${AFT_MGMT_ROLE} in aft-management account:" ${AFT_MGMT_ACCOUNT}
  echo "aws sts assume-role --role-arn arn:aws:iam::${AFT_MGMT_ACCOUNT}:role/${AFT_MGMT_ROLE} --role-session-name ${ROLE_SESSION_NAME}"
  JSON=$(aws sts assume-role --role-arn arn:aws:iam::${AFT_MGMT_ACCOUNT}:role/${AFT_MGMT_ROLE} --role-session-name ${ROLE_SESSION_NAME})
  #Make newly assumed role default session
  export AWS_ACCESS_KEY_ID=$(echo ${JSON} | jq --raw-output ".Credentials[\"AccessKeyId\"]")
  export AWS_SECRET_ACCESS_KEY=$(echo ${JSON} | jq --raw-output ".Credentials[\"SecretAccessKey\"]")
  export AWS_SESSION_TOKEN=$(echo ${JSON} | jq --raw-output ".Credentials[\"SessionToken\"]")

  # Assume AWSCICDExecution in User Defined account
  echo "aws sts assume-role --role-arn arn:aws:iam::${USER_DEFINED_ACCOUNT_ID}:role/${AFT_EXECUTION_ROLE} --role-session-name ${ROLE_SESSION_NAME}"
  JSON=$(aws sts assume-role --role-arn arn:aws:iam::${USER_DEFINED_ACCOUNT_ID}:role/${AFT_EXECUTION_ROLE} --role-session-name ${ROLE_SESSION_NAME})
  echo "[default]" >> ~/.aws/credentials
  echo "aws_access_key_id=$(echo ${JSON} | jq --raw-output ".Credentials[\"AccessKeyId\"]")" >> ~/.aws/credentials
  echo "aws_secret_access_key=$(echo ${JSON} | jq --raw-output ".Credentials[\"SecretAccessKey\"]")" >> ~/.aws/credentials
  echo "aws_session_token=$(echo ${JSON} | jq --raw-output ".Credentials[\"SessionToken\"]")" >> ~/.aws/credentials

  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
fi

echo "Script execution complete"
