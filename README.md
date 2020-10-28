#current version terrafrom 11
#state file stored in S3

# What you did with Terraform
Oh, basically, I have used terraform for infrastructure as a code to services on top of cloud providers (AWS/GCP/Azure), In terms of AWS I used terraform especially like Spinning up EC2 instances, s3.
Also, I am are pretty much focusing on any kind of like auto scaling groups, elbs, so that we're basically we can try to like spinning up either mutable, or immutable infrastructure around.
So, that where we try to work heavily with most of the modules within terraform like nested modules, console models, crypto models to make a certain template to mean more reusable and have a will use like terraform version 11. Where I managed most of the state files using like terraform workspaces and terraform file layouts.

# Terraform Script:
Create a folder->Sample.tf -> Terraform init -> Terraform plan & apply
Terraform destroy – to delete the configuration
Terraform -version -> to check terraform version


# Terraform Secrets Management: Hashicorp Vault

# What you don’t Like in terraform: 

1.	Unlike other tools terraform will take time to update resources/parameters. Which means Time Consuming.
2.	No operations work only used as IAAC.
3.	Certain configuration like terraform backend cannot be read from var files. So, either provide the details in-situ or write a backend-config block while initializing Terraform.
4.	No error handling.
5.	No way to Rollback. So, we need to destroy everything and re-run if required.

# Terraform Vs Ansible

Terraform is an orchestration tool. Ansible is mainly a configuration management tool (CM); they perform differently but do have some overlaps since these functions are not mutually exclusive. Optimized for various usage and strengths, use these tools for situations.

