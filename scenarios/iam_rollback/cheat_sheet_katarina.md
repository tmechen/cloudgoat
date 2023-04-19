`aws configure --profile katarina`

`aws iam list-attached-user-policies --user-name katarina --profile katarina`

`aws iam list-policy-versions --policy-arn <generatedARN>/katarina-policy --profile katarina`

`aws iam get-policy-version --policy-arn <generatedARN>/katarina-policy --version-id <versionID> --profile katarina`

`aws iam set-default-policy-version --policy-arn <generatedARN>/katarina-policy --version-id <versionID> --profile katarina`
