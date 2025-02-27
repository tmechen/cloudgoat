
# Scenario: lambda_sqli

**Size:** Small  
**Difficulty:** Easy

**Command:** `$ ./cloudgoat.py create lambda_sqli`

## Scenario Resources

1 IAM User  
1 IAM Role  
1 Lambda   
1 Secret 

## Scenario Start(s)

1. IAM User 'Emily' 

## Scenario Goal(s)

Find the scenario's secret. (cg-secret-XXXXXX-XXXXXX)

## Summary

In this scenario, you start as the 'Emily' user. You will assume a role with more privileges, discover a 
lambda function that applies policies to users, and exploit a vulnerability in the function to escalate 
the prrivileges of the Emily user in order to search for secrets. 

## Exploitation Route

![Lucidchart Diagram](exploitation_route.png "Exploitation Route")


## Walkthrough - IAM User "Emily"

1. Get permissions for the 'Emily' user.
2. List all roles.
3. List lambdas to identify the target lambda.
4. Look at the lambda source code.
5. Assume the lambda invoker role.
6. Craft an injection payload to send through the CLI.
7. Base64 encode that payload. The single quote injection character is not compatible with the aws cli command otherwise.
8. Invoke the policy applier lambda function, passing the name of the Emily user and the injection payload. 
9. Now that Emily is an admin, use credentials for that user to list secrets from secretsmanager. 

A cheat sheet for this route is available [here](./cheat_sheet.md).
