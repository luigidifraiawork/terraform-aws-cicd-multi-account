#!/bin/bash
# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

#Default flags to false
USER_DEFINED_ACCOUNT=false
AFT=false

#Ensure at option was specified
if [ $# -eq 0 ]; then
  echo "";
  echo "No options have been provided.";
  exit;
fi

#Parse options and set flags
while [ ! $# -eq 0 ]
do
  case "$1" in
    --account-id)
      USER_DEFINED_ACCOUNT=true
      USER_DEFINED_ACCOUNT_ID=$2
      echo $ACCOUNT_ID
      ;;
    --aft-mgmt)
      AFT=true
      ;;
    --help)
      echo ""
      echo "creds.sh creates an AWS CLI credential file leveraging AWSAFTExecutionRole for specified accounts"
      echo ""
      echo "** creds.sh should be run from the AFT Management account with a role that can assume aws-aft-AdministratorRole **"
      echo ""
      echo "usage: creds.sh [--account account_id] [--ct-mgmt] [--aft-mgmt]"
      echo ""
      echo "--account-id - Create a default credential profile for the given account number.   Profile name: default"
      echo "--aft-mgmt   - Create a credential profile for AFT Management account.             Profile name: aft-management"
      exit
      ;;
  esac
  shift
done

# Remove Credentials file, if exists
mkdir -p ~/.aws
rm -f ~/.aws/credentials

#Lookup SSM Parameters
AFT_MGMT_ROLE=$(aws ssm get-parameter --name /aft/resources/iam/aft-administrator-role-name | jq --raw-output ".Parameter.Value")
AFT_EXECUTION_ROLE=$(aws ssm get-parameter --name /aft/resources/iam/aft-execution-role-name | jq --raw-output ".Parameter.Value")
ROLE_SESSION_NAME=$(aws ssm get-parameter --name /aft/resources/iam/aft-session-name | jq --raw-output ".Parameter.Value")
AFT_MGMT_ACCOUNT=$(aws ssm get-parameter --name /aft/account/aft-management/account-id | jq --raw-output ".Parameter.Value")

# Assume aws-aft-AdministratorRole in AFT Management account
if $USER_DEFINED_ACCOUNT || $AFT; then
  echo "Assuming ${AFT_MGMT_ROLE} in aft-management account:" ${AFT_MGMT_ACCOUNT}
  echo "aws sts assume-role --role-arn arn:aws:iam::${AFT_MGMT_ACCOUNT}:role/${AFT_MGMT_ROLE} --role-session-name ${ROLE_SESSION_NAME}"
  JSON=$(aws sts assume-role --role-arn arn:aws:iam::${AFT_MGMT_ACCOUNT}:role/${AFT_MGMT_ROLE} --role-session-name ${ROLE_SESSION_NAME})
  #Make newly assumed role default session
  export AWS_ACCESS_KEY_ID=$(echo ${JSON} | jq --raw-output ".Credentials[\"AccessKeyId\"]")
  export AWS_SECRET_ACCESS_KEY=$(echo ${JSON} | jq --raw-output ".Credentials[\"SecretAccessKey\"]")
  export AWS_SESSION_TOKEN=$(echo ${JSON} | jq --raw-output ".Credentials[\"SessionToken\"]")
fi

if $USER_DEFINED_ACCOUNT; then
# Assume AWSAFTExecution in User Defined account
  echo "aws sts assume-role --role-arn arn:aws:iam::${USER_DEFINED_ACCOUNT_ID}:role/${AFT_EXECUTION_ROLE} --role-session-name ${ROLE_SESSION_NAME}"
  JSON=$(aws sts assume-role --role-arn arn:aws:iam::${USER_DEFINED_ACCOUNT_ID}:role/${AFT_EXECUTION_ROLE} --role-session-name ${ROLE_SESSION_NAME})
  echo "[default]" >> ~/.aws/credentials
  echo "aws_access_key_id=$(echo ${JSON} | jq --raw-output ".Credentials[\"AccessKeyId\"]")" >> ~/.aws/credentials
  echo "aws_secret_access_key=$(echo ${JSON} | jq --raw-output ".Credentials[\"SecretAccessKey\"]")" >> ~/.aws/credentials
  echo "aws_session_token=$(echo ${JSON} | jq --raw-output ".Credentials[\"SessionToken\"]")" >> ~/.aws/credentials
fi

if $AFT; then
# Assume AWSAFTExecution in AFT Management account
  echo "Assuming ${AFT_EXECUTION_ROLE} in aft-management account:" ${AFT_MGMT_ACCOUNT}
  echo "aws sts assume-role --role-arn arn:aws:iam::${AFT_MGMT_ACCOUNT}:role/${AFT_EXECUTION_ROLE} --role-session-name ${ROLE_SESSION_NAME}"
  JSON=$(aws sts assume-role --role-arn arn:aws:iam::${AFT_MGMT_ACCOUNT}:role/${AFT_EXECUTION_ROLE} --role-session-name ${ROLE_SESSION_NAME})
  # Create credentials file
  echo "[aft-management]" >> ~/.aws/credentials
  echo "aws_access_key_id=$(echo ${JSON} | jq --raw-output ".Credentials[\"AccessKeyId\"]")" >> ~/.aws/credentials
  echo "aws_secret_access_key=$(echo ${JSON} | jq --raw-output ".Credentials[\"SecretAccessKey\"]")" >> ~/.aws/credentials
  echo "aws_session_token=$(echo ${JSON} | jq --raw-output ".Credentials[\"SessionToken\"]")" >> ~/.aws/credentials
fi

# Unset env vars if any work was performed
if $USER_DEFINED_ACCOUNT || $AFT; then
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
fi
echo "Script execution complete"
