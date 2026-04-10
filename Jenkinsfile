pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'restaurent-website'
        DOCKER_TAG   = "${BUILD_NUMBER}"
        REGISTRY     = ''  // e.g. 'your-dockerhub-username' or ECR URI
        KUBE_NAMESPACE = 'production'
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    echo "Pushing Docker image to registry..."
                    // Uncomment and configure for your registry:
                    // withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    //     sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    //     sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    //     sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${REGISTRY}/${DOCKER_IMAGE}:latest"
                    //     sh "docker push ${REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    //     sh "docker push ${REGISTRY}/${DOCKER_IMAGE}:latest"
                    // }
                    echo "Skipping push — configure REGISTRY and credentials above."
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying to Kubernetes namespace: ${KUBE_NAMESPACE}"
                    sh "kubectl apply -f k8s/deployment.yaml -n ${KUBE_NAMESPACE}"
                    sh "kubectl apply -f k8s/service.yaml -n ${KUBE_NAMESPACE}"
                    sh "kubectl apply -f k8s/ingress.yaml -n ${KUBE_NAMESPACE}"
                    sh "kubectl set image deployment/restaurent-website restaurent-website=${DOCKER_IMAGE}:${DOCKER_TAG} -n ${KUBE_NAMESPACE}"
                    sh "kubectl rollout status deployment/restaurent-website -n ${KUBE_NAMESPACE} --timeout=120s"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully! Deployment is live.'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
            script {
                // Rollback to previous version on failure
                sh "kubectl rollout undo deployment/restaurent-website -n ${KUBE_NAMESPACE} || true"
            }
        }
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
