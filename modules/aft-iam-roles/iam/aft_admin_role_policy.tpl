{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": [
        "arn:aws:iam::*:role/AWSCICDExecution",
        "arn:aws:iam::*:role/AWSCICDService"
      ]
    }
  ]
}
