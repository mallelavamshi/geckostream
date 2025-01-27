pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'estate-genius-ai'
        DOCKER_TAG = "${BUILD_NUMBER}"
        ANTHROPIC_API_KEY = credentials('anthropic-api-key')
        SEARCH_API_KEY = credentials('search-api-key')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Add your test commands here
                    sh 'echo "Running tests..."'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Stop existing container if running
                    sh '''
                        docker ps -q --filter "name=estate-genius" | grep -q . && docker stop estate-genius || true
                        docker ps -aq --filter "name=estate-genius" | grep -q . && docker rm estate-genius || true
                    '''
                    
                    // Run new container
                    sh """
                        docker run -d \
                            --name estate-genius \
                            -p 8501:8501 \
                            -e ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY} \
                            -e SEARCH_API_KEY=${SEARCH_API_KEY} \
                            ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    // Remove old images
                    sh """
                        docker images ${DOCKER_IMAGE} -q | xargs -r docker rmi || true
                    """
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}