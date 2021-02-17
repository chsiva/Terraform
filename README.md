#current version terrafrom 11
#state file stored in S3

# Terrform VS CFT/ARM

Terraform with increase in uasbility for hybrid cloud deployment. CFT is limitied to only AWS. In terrform we can chosse the provide let be aws/azure/gcp and we can use terroform to provision any kind of resouce in cloud. Also if you want to use Ansible you can use ansible provider and kick it off with Terraform. which comes in very handy and very node productive when comparing to CFT.


# Terraform Execution Setup

So let say If we want to provision a Virtual machine in AWS/Azure cloud, what we do is we start doing a main.tf or let say like ec2.tf and we start using by the provider and setting up the keys. For security best practicess we we not store any keys open instead we will encrypt (vault mechanism in CICD process) and call these tokens into the vars file. Then we starting writing the resource blocks to provision ec2 instance.

After the main.tf file is ready, we start setup the CICD process andhave all the dependencies which is listed in the  pipeline as a code which is the jenkins file.

We desbribe the terraform execution steps like Terraform init, plan, apply, destroy in Jenkins file and then we kick off the cicd process. Once this entire process id done it will now deploy the resources into the cloud.

# How Terraform will deploy into multiple environments

Depending on the parametered inputs we will choose our environment. we can use a loca file or jenkins file to be parametered in CICD setup. once environemnt is done it kicks off the dev based configuration setup and deploy it not the specific environment.


# Terraform Script:
Create a folder->Sample.tf 

-> Terraform init---->Terraform plan & apply

->Terraform destroy–---> to delete the configuration

-->Terraform -version -> to check terraform version


# Terraform Secrets Management: Hashicorp Vault

# What you don’t Like in terraform: 

1.	Unlike other tools terraform will take time to update resources/parameters. Which means Time Consuming.
2.	No operations work only used as IAAC.
3.	Certain configuration like terraform backend cannot be read from var files. So, either provide the details in-situ or write a backend-config block while initializing Terraform.
4.	No error handling.
5.	No way to Rollback. So, we need to destroy everything and re-run if required.

# Terraform Vs Ansible

Terraform is an orchestration tool. Ansible is mainly a configuration management tool (CM); they perform differently but do have some overlaps since these functions are not mutually exclusive. Optimized for various usage and strengths, use these tools for situations.

# Terrofrm plugins

The Terraform AWS provider is a plugin for Terraform that allows for the full lifecycle management of AWS resources.

So, as an end-user you are using AWS provider.
But if you want to contribute to the provider, and implement or fix bugs in it, you will be doing this in in a context of a plugin in go language.

# inside Json file

{
  "type": "service_account",
  
  "project_id": "gcp-dev-300323",
  
  "private_key_id": " ",
  
  "private_key": "-----BEGIN PRIVATE KEY-----
  
  "client_email": "terraform-gcp@gcp-dev-300323.iam.gserviceaccount.com",
  
  "client_id": " ",
  
  "auth_uri": " ",
  
  "token_uri": " ",
  
  "auth_provider_x509_cert_url": " ",
  
  "client_x509_cert_url": ""
}

# So you could have a .vars file with Vpc value and calling this in main.tf

