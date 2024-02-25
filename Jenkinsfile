pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        APP_NAME = "java-registration-app"
        RELEASE = "1.0.0"
        DOCKER_USER = 'ravipatil44'
        DOCKER_PASS = 'docker-hub'
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }
    stages {
        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from Git') {
            steps {
                git branch: 'main', credentialsId: 'git-hub', url: 'https://github.com/ravipatil4414/my-project.git'
            }
        }
        stage('Build Package') {
            steps {
                dir('webapp') {
                    sh 'mvn package'
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    dir('webapp') {
                        sh 'mvn -U clean install sonar:sonar'
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token'
                }
            }
        }
        stage('Artifactory configuration') {
            steps {
                rtServer (
                    id: "jfrog-server",
                    url: "http://13.233.238.126:8082/artifactory",
                    credentialsId: "jfrog"
                )
                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "jfrog-server",
                    releaseRepo: "libs-release-local",
                    snapshotRepo: "libs-snapshot-local"
                )
                rtMavenResolver (
                    id: "MAVEN_RESOLVER",
                    serverId: "jfrog-server",
                    releaseRepo: "libs-release",
                    snapshotRepo: "lib-snapshot"
                )
            }
        }
        stage('Deploy Artifacts') {
            steps {
                rtMavenRun (
                    tool: "maven",
                    pom: 'webapp/pom.xml',
                    goals: 'clean install',
                    deployerId: "MAVEN_DEPLOYER",
                    resolverId: "MAVEN_RESOLVER"
                )
            }
        }
        stage('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "jfrog-server"
                )
            }
        }
    }
}

