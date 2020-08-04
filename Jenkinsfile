pipeline {
  agent any

  stages {
    stage("Create Environmnet") {
      steps {
        withCredentials([[
        						$class: 'AmazonWebServicesCredentialsBinding',
        						credentialsId: params.AWSCredentials,
        						accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        						secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        				]]) {
        					ansiColor('xterm') {
        						sh 'terraform init'
        					}
        }
      }
    }
    stage("Plan") {
      steps {
        withCredentials([[
            $class: "AmazonWebServicesCredentialsBinding",
            credentialsId: params.awsCredentials,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
          ]]) {
            ansiColor('xterm') {
              sh 'terraform plan'
            }
          }
      }
    }
    stage("Apply") {
      steps {
        withCredentials([[
            $class: "AmazonWebServicesCredentialsBinding",
            credentialsId: params.awsCredentials,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
          ]]) {
            ansiColor('xterm') {
              sh 'terraform apply'
            }
          }
      }
    }
  }
}
