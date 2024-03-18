pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', credentialsId: 'git-hub', url: 'https://github.com/ravipatil4414/java_project.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package' // Maven build to generate WAR
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    docker.build('my-java-app', '-f Dockerfile .') // Build Docker image using Dockerfile
                }
            }
        }
        
        stage('Docker Run') {
            steps {
                script {
                    sh 'docker run -p 9090:9090 --name my-java-app-container-jar -d my-java-app-jar' // Run Docker container in detached mode
                }
            }
        }
    }
}
