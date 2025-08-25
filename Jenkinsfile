pipeline {
    agent any

    environment {
        TERRAFORM_DIR = 'terraform'
        CONTAINER_NAME = 'nginx'
        HOST_PORT = '8081'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/ikanko1989/jenkins-terraform-docker.git', branch: 'main'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Verify Container') {
            steps {
                sh "docker ps | grep ${CONTAINER_NAME}"
                echo "NGINX should be running on port ${HOST_PORT}"
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        failure {
            echo 'Pipeline failed, check logs.'
        }
    }
}
