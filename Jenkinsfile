String AWSCredentials = params.AWSCredentials

pipeline {
	agent any
	stages {
		stage('Terraform INIT') {
			steps {
				withCredentials([[
						$class: 'AmazonWebServicesCredentialsBinding',
						credentialsId: AWSCredentials,
						accessKeyVariable: 'AWS_ACCESS_KEY_ID',
						secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					ansiColor('xterm') {
						sh 'terraform init'
					}
				}
			}
		}
		stage('Plan Resources') {
			steps {
				withCredentials([[
						$class: 'AmazonWebServicesCredentialsBinding',
						credentialsId: AWSCredentials,
						accessKeyVariable: 'AWS_ACCESS_KEY_ID',
						secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					ansiColor('xterm') {
						sh 'terraform plan -out resource.plan'
					}
				}
			}
		}
		stage('Deploy Resources') {
			steps {
				withCredentials([[
						$class: 'AmazonWebServicesCredentialsBinding',
						credentialsId: AWSCredentials,
						accessKeyVariable: 'AWS_ACCESS_KEY_ID',
						secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					ansiColor('xterm') {
						sh 'terraform apply resource.plan'
					}
				}
			}
		}
	}
}
