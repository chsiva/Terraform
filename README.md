#Basics

    Language: HCL
    current version terrafrom  > 1.3-1.5 are latest
    state file stored in AWS S3/GCP Cloud storage
    
# terraform folder structure

Inside terraform repo -> Modules , Providers, workspaces, main.tf, vars.tf, output.tf, backend.tf

project-root/
├── .gitignore
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── .terraform/                # Terraform-generated state and modules
├── modules/                   # Reusable modules for different resources
│   ├── network/               # Network module (e.g., VPC, subnets)
│   ├── compute/               # Compute module (e.g., VM, instance groups)
│   └── storage/               # Storage module (e.g., Cloud Storage buckets)
├── workspaces/                # Subdirectories for different workspaces
│   ├── dev/                   # Development workspace
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── provider.tf        # Workspace-specific provider configurations
│   ├── staging/               # Staging workspace
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── provider.tf
│   └── production/            # Production workspace
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── provider.tf


# Terraform commnds

   ![image](https://github.com/user-attachments/assets/2059c7a6-a297-4db0-b00b-f9354a7409fb)


# Terrofm Issues

    * statefile lock - remove
    * corrupted statefile - 
    * incompatible with provider version - module of GCP outdated
    * Error code 409 - Resource not found
    * 
# Terraform module inside Ansible
https://docs.ansible.com/ansible/2.9/modules/terraform_module.html
https://medium.com/on-the-cloud/one-click-environment-creation-with-terraform-ansible-in-under-10-6e8d9284f60

# Terrform VS CFT/ARM

Terraform with increase in uasbility for hybrid cloud deployment. CFT is limitied to only AWS. In terrform we can chosse the provide let be aws/azure/gcp and we can use terroform to provision any kind of resouce in cloud. Also if you want to use Ansible you can use ansible provider and kick it off with Terraform. which comes in very handy and very node productive when comparing to CFT.

If your infrastructure relies on many third-party resources, Terraform might be a better fit.

# How you will see logs in terraform
Terraform has detailed logs which can be enabled by setting the TF_LOG environment variable to any value. This will cause detailed logs to appear on stderr. You can set TF_LOG to one of the log levels TRACE , DEBUG , INFO , WARN or ERROR to change the verbosity of the logs.

For ex: export TF_LOG="DEBUG" in shell

Bash: export TF_LOG_PATH="tmp/terraform.log"


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
Lifecycle management of infrastructure lends itself to a Terraform declarative approach, whereas the imperative approach of Ansible is better suited to configuration management because of its customizability.

https://cloudify.co/blog/ansible-vs-terraform/

# Terrofrm plugins

Terraform Plugins: These are executable binaries written in Go that communicate with Terraform Core over an RPC interface. Each plugin exposes an implementation for a specific service, such as the AWS provider or the cloud-init provider.

The Terraform AWS provider is a plugin for Terraform that allows for the full lifecycle management of AWS resources.

So, as an end-user you are using AWS provider.
But if you want to contribute to the provider, and implement or fix bugs in it, you will be doing this in in a context of a plugin in go language.

~/.terraform.d/plugins for Linux and MacOS.

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

