# SAAS-application
Case study for a saas application
The following repo contains the files for a saas application as follows:
1. The application has been written and created in Terraform, terraform_version": "0.15.0" for AWS cloud.
   Info of the same will be found in the provider.tf file
2. I have the lambda.tf file in which 3 resources have been created 
   viz starting from the s3 bucket, the api gateway and the lamda fucntion.
3. I have the output folder in which the zip file for the lambda function is outputted which is indirectly stored in the s3 bucket that I create.
4. The lambda-iam.tf is the file in which the policy and the role required to execute the lambda function have been defined.
5. Next I have the lambda-policy.json and the lambda-assume-policy.json which are the files in which the permissions which are allowed and the role to assume have been defined which directly interact with the lambda-iam.tf file
6. Finally I have the welcome.py which is a simple print statement function written in python that our api is going to make a call to which will then execute the lambda function.![case_study](https://user-images.githubusercontent.com/77860339/129880213-f8c0a1ce-0afd-4f60-8280-c6196492b00d.png)

