pipeline {
    agent any

    environment {
        REGISTRY = "your-dockerhub-username"
        IMAGE = "shift-scheduler"
        TAG = "${BUILD_NUMBER}"
        KUBE_CONFIG = credentials('kube-config')   // Jenkins secret for K8s access
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/youruser/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $REGISTRY/$IMAGE:$TAG ."
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                       echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                       docker push $REGISTRY/$IMAGE:$TAG
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kube-config', variable: 'KUBECONFIG')]) {
                    sh """
                       kubectl --kubeconfig=$KUBECONFIG set image deployment/shift-scheduler-canary shift-scheduler=$REGISTRY/$IMAGE:$TAG -n academy
                       kubectl --kubeconfig=$KUBECONFIG rollout status deployment/shift-scheduler-canary -n academy
                    """
                }
            }
        }
    }
}
