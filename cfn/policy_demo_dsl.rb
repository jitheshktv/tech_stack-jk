require 'json'

CloudFormation {

  IAM_Role('billingAdmin') {
    AssumeRolePolicyDocument (JSON.load <<-END
      {
        "Statement": [
          {
            "Action": [
              "sts:AssumeRole"
            ],
            "Effect":"Allow",
            "Principal": {
              "Service": [
                "ec2.amazonaws.com"
              ]
            }
          }
        ]
      }
    END
    )

    Policies [
      {
        'PolicyName' => 'billingAdminPolicy',
        'PolicyDocument' => (JSON.load <<-END
          {
            "Version": "2012-10-17",
            "Statement": [
              {
                "Effect": "Allow",
                "Action": [
                  "aws-portal:*Billing",
                  "aws-portal:ViewUsage"
                ],
                "Resource": [
                  "*"
                ]
              }
            ]
          }
        END
        )
      }
    ]
  }
}
