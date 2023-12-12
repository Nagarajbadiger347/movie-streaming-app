pipeline {
    agent any

    tools {
        jdk 'JDK-17'
        nodejs 'nodejs'
    }

    environment {
        SCANNER_HOME = tool 'sonarqube-scannar'
    }

    stages {
        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Nagarajbadiger347/DevSecOps.git'
            }
        }

        stage("Sonarqube Scanning ") {
            steps {
                script {
                    withSonarQubeEnv('sonarqube-server') {
                        sh "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectName=Netflix -Dsonar.projectKey=Netflix"
                    }
                }
            }
        }

        stage("quality gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
    }
}
