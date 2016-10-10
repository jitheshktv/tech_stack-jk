require 'json'

CloudFormation {
  Description 'Create an S3 Bucket for Bucket Policy Testing'
  OrchestratorName ||= 'notset'

  bucket_name = "citi-policy-test-#{OrchestratorName}"

  S3_Bucket('s3bucket') {
    BucketName bucket_name
  }

  S3_BucketPolicy('TestBucketPolicy') {
    Bucket Ref('s3bucket')
    PolicyDocument JSON.load <<-END
      {
        "Version": "2012-10-17",
        "Id": "PutObjPolicy",
        "Statement": [
          {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::#{bucket_name}/*",
            "Condition": {
              "StringNotEquals": {
                "s3:x-amz-server-side-encryption": "AES256"
              }
            }
          },
          {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::#{bucket_name}/*",
            "Condition": {
              "Null": {
                "s3:x-amz-server-side-encryption": true
              }
            }
          }
        ]
      }
    END
  }

  Output(:s3BucketName,
         Ref('s3bucket'))
}
