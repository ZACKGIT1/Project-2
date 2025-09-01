pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'your-dockerhub-username/go-cicd'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/go-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push("latest")
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh 'docker-compose down'
                sh 'docker-compose pull'
                sh 'docker-compose up -d'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
