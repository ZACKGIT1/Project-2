pipeline {
    agent { label 'node1' }
    
    environment {
        DOCKER_IMAGE = 'zackpfannerstill19/project-2'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/ZACKGIT1/Project-2.git'
            }
        }
        
        stage('Docker Build and Tag') {
            steps {
                script {
                    echo 'Docker Build and Tag started'
                    echo "Building Docker image ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Image Push to Docker Hub') {
            steps {
                script {
                    echo 'Docker Push to Docker Hub started'
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-cred',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh """
                            echo "\$DOCKER_PASSWORD" | docker login -u "\$DOCKER_USERNAME" --password-stdin
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            docker logout
                        """
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    sh """
                        export DOCKER_IMAGE=${DOCKER_IMAGE}
                        export DOCKER_TAG=${DOCKER_TAG}
                        docker-compose down
                        docker-compose pull
                        docker-compose up -d
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
