{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
    "Resource": "${resource}"
  }
}