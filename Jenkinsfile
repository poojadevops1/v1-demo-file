pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'  // Set your AWS region
        ECR_REPO = '061051222584.dkr.ecr.us-east-1.amazonaws.com/jenkins-repo'  // Set your ECR repository URL
        IMAGE_TAG = "${BUILD_NUMBER}"  // Use Jenkins build number as the tag
    }
    stages{
    stage('Docker Build') {
            steps {
                echo 'Building Docker image...'
                script {
                    dockerImage = docker.build("${env.ECR_REPO}:${env.IMAGE_TAG}")
                }
            }
        }
         stage('Docker Push to ECR') {
            steps {
                echo 'Pushing Docker image to Amazon ECR...'
                script {
                    // Use Jenkins' withCredentials to securely bind AWS credentials
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-ecr-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        // Login to AWS ECR using AWS CLI
                        sh '''
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                        '''
                        // Push Docker image
                        dockerImage.push("${env.IMAGE_TAG}")
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build succeeded!'
        }

        failure {
            echo 'Build failed!'
        }
    }
}

