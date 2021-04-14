pipeline {
    agent any

  environment {
      tf_version = '0.14.9'
      config_path = '/var/lib/jenkins/workspace/testpipeline'
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
