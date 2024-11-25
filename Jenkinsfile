pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '061051222584.dkr.ecr.us-east-1.amazonaws.com/jenkins-repo'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Verify Build Context') {
            steps {
                sh 'ls -la'
            }
        }
        stage('Cleanup') {
    steps {
        sh 'docker system prune -f'
    }
}


        stage('Check Docker Access') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Verify Environment Variables') {
            steps {
                echo "AWS_REGION=${env.AWS_REGION}"
                echo "ECR_REPO=${env.ECR_REPO}"
                echo "IMAGE_TAG=${env.IMAGE_TAG}"
            }
        }

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
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-ecr-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh '''
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                        '''
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
