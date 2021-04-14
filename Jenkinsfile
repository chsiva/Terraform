pipeline {
    agent any

  environment {
      tf_version = '0.14.9'
      config_path = '/var/lib/jenkins/workspace/testpipeline'
    }

    parameters {
        booleanParam(defaultValue: false, description: 'Set Value to True to Initiate Destroy Stage', name: 'destroy')
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
    }

    stages {
        stage('Builder') {
            steps {
                withCredentials([file(credentialsId: 'Project', variable: 'Project')]) {
               sh"""
               rm -rf *
               echo \${Project} > service-account.json
               ls -al
               """
                }
            }
        }
        stage('TerraRising') {
            steps {

                 sh '''#!/bin/bash -l
                 
                 # Setting up Terraform in build environment
                 echo "Downloading Terraform ${tf_version}"
                 wget -q https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip
                 unzip -qo terraform_${tf_version}_linux_amd64.zip
                 chmod 755 terraform
                 ./terraform --version
                 # Remove previous terraform modules
                 rm -rf .terraform
                  
                 # Setups up Terraform state file and source modules
                 set -x #Turns on screen outputs
                 ./terraform init
                 '''
            }
        }
        stage('TerraPlanning') {
            when {
                expression { !params.destroy }
            }
            steps {
                echo "Terraform Plann"

                sh '''#!/bin/bash -l
                  echo "Terraform Plan"
                  set -x
                  ./terraform plan -out=current.tfplan
                  '''

            }
        }

        stage('TerraDestroy') {
            when {
                expression { params.destroy }
            }
            steps {
                echo "Terraform Destroy"

                sh '''#!/bin/bash -l
                  echo "Terraform Destroy"
                  set -x
                  ./terraform destroy -auto-approve
                  '''

            }
        }

        stage("ValidateBeforeDeploy") {
            when {
                expression { !params.destroy }
            }
            steps {
                input 'Are you sure? Review the output of the previous step before proceeding!'
            }
        }

        stage('TerraApplying') {
            when {
                expression { !params.destroy }
            }
            steps {
                withCredentials([file(credentialsId: 'Project', variable: 'Project')]) {
                sh '''#!/bin/bash -l
                  echo "Terraform Apply"
                  set +x
                  ./terraform apply current.tfplan
                  '''
            }
        }
        }
        stage('Clean Workspace'){
            steps {
                sh '''#!/bin/bash -l
                echo "cleaning workspace"
                set +x
                rm -rf $WORKSPACE/*
                '''
            }
        }
    }
}
