# Terraform
    Terraform is an Infrastructure as Code (IaC) tool that can create immutable infrastructure. 
      immutable infrastructure means that once you deploy a server or other infrastructure component, you never modify it directly
      lockfile: .terraform.lock.hcl
      statefile: terraform.tfstate
      backupfile; terraform.tfstate.backup
    HashiCorp Configuration Language (HCL)

#Basics

    Language: HCL
    current version terrafrom  > 1.3-1.9 are latest
    state file stored in AWS S3/GCP Cloud storage
      
# Updating Labels or Tags on an Immutable EC2 Instance:

    This is where the concept of immutability might seem to conflict with direct updates:
    - Internal configuration changes: 
         Changes made inside the running EC2 instance (such as updating an application or patching the OS). These should be handled by replacing the instance.
    - External metadata or attributes: Changes to the resource itself, like its labels (tags in AWS terminology). These can often be updated in place by the cloud provider's API. 

#Terraform recreating vm with updating config

    When you run terraform apply with this updated configuration,
       Terraform will plan to destroy the old instance and create a new one with the new AMI. 
       Example: machine type, machine image, moving vm a different subnet, GCS bucket ( name, location)

# Avoid dataloss
    seperate data volume [ persistent volumes (like EBS volumes in AWS) ]
    Attach old data voulmes this to new VM
    Mount Volumes Without Reformatting: 
    Backup and Recovery Strategies like "snapshot"
    prevent_destroy = true # this will block perform action but will not create a new vm as well

#Avoid other users to remove/release lock

   How it works (example with GCS bucket):  lockfile will be 
   
       - Configure your Terraform configuration: You'll specify the S3 bucket where the state file will be stored and the DynamoDB table for locking in the backend block.
       - Initialize Terraform: When you run terraform init, Terraform sets up the remote backend and enables state locking.
       - Run a command (e.g., terraform apply): Terraform checks the DynamoDB table for an existing lock.
       - Acquire lock: If no lock exists, Terraform creates one in the DynamoDB table. This prevents others from running commands that would modify the state.
       - Perform operation: Terraform proceeds with the requested operation (e.g., applying changes).
       - Release lock: Once the operation is complete, Terraform releases the lock in the DynamoDB table. 
       
        terraform {
          backend "s3" {
            bucket         = "your-terraform-state-bucket"  # Replace with your bucket name
            key            = "terraform/state"              # Path to your state file
            region         = "us-west-2"                    # AWS region
            dynamodb_table = "terraform-lock-table"         # Replace with your DynamoDB table name
          }
        }

        This configuration tells Terraform to store the state file in the specified S3 bucket at the given key 
               and to use the terraform-lock-table DynamoDB table for state locking

        Example of Lock Information in DynamoDB:
            When a Terraform command like terraform apply is run and acquires a lock,
            an item will be created in your DynamoDB lock table. You can view this item using the AWS CLI: 
            
            $aws dynamodb scan --table-name terraform-lock-table --profile=<your_aws_profile>
            $aws dynamodb scan --table-name <your_lock_table_name> --profile=<your_aws_profile>

           



    
# terraform folder structure

    Inside terraform repo -> 
      Modules , Providers, workspaces, main.tf, vars.tf, output.tf, backend.tf

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

#TERRAFORM .tpl or .tftpl extension

    In Terraform, a file with a .tpl or .tftpl extension is typically a template file. 
    These template files are used to dynamically generate text-based content, 
        such as configuration files, scripts, or user data, based on data provided by Terraform. 

        Example:
        
        Let's say you have a template file named user_data.tftpl to configure an EC2 instance: 
        
        bash
        
        #!/bin/bash
        echo "Hello, ${username}!" > /home/ec2-user/welcome.txt
        Use code with caution.
        
        In your Terraform configuration, you can use the templatefile function to dynamically set the username and use this template as the user_data for your EC2 instance: 
        terraform
        resource "aws_instance" "web" {
          ami           = "ami-12345678"
          instance_type = "t2.micro"
          user_data     = templatefile("${path.module}/user_data.tftpl", {
            username = "Terraform User"
          })
        }
        Use code with caution.
        
        This will generate a user data script that, when the instance launches, will write "Hello, Terraform User!" to a file named welcome.txt. 
        AI responses may include mistakes. Learn more

# Terraform commnds

   ![image](https://github.com/user-attachments/assets/2059c7a6-a297-4db0-b00b-f9354a7409fb)


# Terrofm Issues

    * statefile lock removal  = $terraform force-unlock <lock-id>
         The lock ID is generally shown in the error message
         Note: To prevent users from removing the lock, 
                 use platforms like Terraform Cloud/Enterprise, 
                 set up automated processes, and control access to the state file [5].
         
    * corrupted statefile - 
         Delete the statefile and get the backfile stored from GCS bucket
         file: terraform.tfstate.backup
          
           Steps to Restore from terraform.tfstate.backup:
                Rename: Rename the terraform.tfstate.backup file to terraform.tfstate.
                Initialize: Run terraform init.
                Apply: Run terraform apply to apply the changes to your infrastructure. 

    * incompatible with provider version - module of GCP outdated
    
    * Error code 409 - Resource not found
       Remove Resource from State:
          If the conflict is due to an interrupted apply or inconsistent state, 
              you might need to use terraform state rm <resource_name> to remove the resource from the state and then terraform import to re-add it correctly.




#Terraform Advance querstions

    - Drift Detection: Recognizing and addressing when your live infrastructure deviates from the desired state defined in your Terraform code, 
                       often caused by manual changes outside of Terraform's control.
              
               Import configuration $terraform import aws_s3_bucket.my_bucket my-existing-bucket

       Solution: 
         - avoiding manual modifications directly in the cloud console or CLI
         - Automate Deployments (CI/CD)
         - Use Remote State and State Locking
         - Use Terraform, where infra is immutable rather than update
    * 
    - Rolling Updates: 
         Implementing strategies like create_before_destroy or Blue/Green deployments to update infrastructure incrementally without causing downtime.
         
         *** create_before_destroy Meta-Argument ***
                resource "aws_instance" "web_server" {
                  ami           = "ami-old-version" # Old AMI ID
                  instance_type = "t2.micro"
                  # ... other configurations ...
                
                  lifecycle {
                    create_before_destroy = true
                  }
                }

           When you update the ami to a new version, Terraform will launch a new EC2 instance with the new AMI before terminating the old one.

          *** Blue/Green Deployment ***

            resource "aws_s3_bucket" "blue_environment" {
              bucket = "my-app-blue"
              # ... configuration for blue environment ...
            }
            
            resource "aws_s3_bucket" "green_environment" {
              bucket = "my-app-green"
              # ... configuration for green environment (updated version) ...
            }
            
            resource "aws_elb" "app_load_balancer" {
              # ... load balancer configuration ...
              instances = [aws_instance.blue_instance.id] # Initially pointing to blue
            }

            To switch to Green, you would update the instances attribute of the load balancer to point to the Green environment's instances and apply the change with Terraform


            In conclusion, Terraform empowers you to implement robust rolling update strategies like create_before_destroy and Blue/Green deployments to ensure continuous availability and minimize downtime during infrastructure updates. By leveraging these techniques and combining them with careful planning and automation, you can achieve safe and predictable deployments of your infrastructure.


    - Dependency Management: Handling resource dependencies, mainly by favoring implicit dependencies (Terraform automatically infers them) 
                             and using explicit dependencies (depends_on) only when necessary for complex scenarios.

         resource "resource_type" "resource_name" {
          # ... resource configuration ...
          depends_on = [resource_type.dependent_resource_name, module.dependent_module_name]
        }
        ```
        Note: reusable

    - Multi-Cloud Deployments: Using Terraform to manage infrastructure across different cloud providers within a single configuration.

                            # Define the AWS provider
                            provider "aws" {
                              region = "us-east-1" # Specify your desired AWS region
                            }
                            
                            # Define the Google Cloud provider
                            provider "google" {
                              project = "your-gcp-project-id" # Replace with your GCP project ID
                              region  = "us-central1"        # Specify your desired GCP region
                            }
                            
                            # AWS: Create an EC2 instance
                            resource "aws_instance" "my_aws_vm" {
                              ami           = "ami-0abcdef1234567890"  # Replace with a valid AMI ID
                              instance_type = "t2.micro"
                              tags = {
                                Name = "MyAWSVM"
                              }
                            }
                            
                            # GCP: Create a Compute Engine instance
                            resource "google_compute_instance" "my_gcp_vm" {
                              name         = "my-gcp-vm"
                              machine_type = "e2-medium" # Specify your desired machine type
                              zone         = "us-central1-a"  # Specify your desired zone
                            
                              boot_disk {
                                initialize_params {
                                  image = "debian-cloud/debian-10" # Specify your desired image
                                }
                              }
                            
                              network_interface {
                                network = "default" # Use the default network or specify a custom one
                                access_config {
                                  // Ephemeral IP
                                }
                              }
                            }
                            
                - Provider Blocks: The aws and google providers are defined in the configuration. 
                                   Credentials for each provider are needed to allow Terraform to authenticate and interact with your cloud accounts.
                - Resource Definitions:
                       aws_instance.my_aws_vm: Defines an EC2 instance in AWS.
                       google_compute_instance.my_gcp_vm: Defines a Compute Engine instance in GCP.
                - Resource-Specific Attributes: Each resource block uses attributes specific to the corresponding cloud provider to configure the resource
                                                (e.g., ami and instance_type for AWS, machine_type and zone for GCP).
                - Implicit Dependencies: In this example, there are no explicit dependencies between the AWS and GCP resources. 
                                          Terraform can provision them in parallel. 
                                          If there were dependencies (e.g., a GCP instance needing to access an AWS resource), 
                                               depends_on or outputs would be used to manage those relationships.
                Running Terraform terraform init, terraform plan, and terraform apply initializes the project, previews the changes, and provisions the VMs in both AWS and GCP. 

     

        - Terraform tains & untaint
        
           You are correct that the terraform taint command is deprecated in newer versions of Terraform, and using terraform apply -replace is the recommended alternative. 

                resource "google_compute_instance" "example" {
                  count = 3  # Creates 3 instances
                  name         = "my-instance-${count.index}"
                  machine_type = "e2-medium"
                  zone         = "us-central1-a"
                
                  boot_disk {
                    initialize_params {
                      image = "debian-cloud/debian-10"
                    }
                  }
                
                  network_interface {
                    network = "default"
                  }
                }
           
              Note: Running terraform apply -replace="google_compute_instance.example[0]" 
                    will force the replacement of the first instance created by this configuration (the one named "my-instance-0")

# Terraform module inside Ansible
https://docs.ansible.com/ansible/2.9/modules/terraform_module.html
https://medium.com/on-the-cloud/one-click-environment-creation-with-terraform-ansible-in-under-10-6e8d9284f60

# Terrform VS CFT/ARM

Terraform with increase in uasbility for hybrid cloud deployment. CFT is limitied to only AWS. In terrform we can chosse the provide let be aws/azure/gcp and we can use terroform to provision any kind of resouce in cloud. Also if you want to use Ansible you can use ansible provider and kick it off with Terraform. which comes in very handy and very node productive when comparing to CFT.

If your infrastructure relies on many third-party resources, Terraform might be a better fit.

# How you will see logs in terraform
Terraform has detailed logs which can be enabled by setting the "TF_LOG environment variable to any value". This will cause detailed logs to appear on stderr. You can set TF_LOG to one of the log levels TRACE , DEBUG , INFO , WARN or ERROR to change the verbosity of the logs.

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

