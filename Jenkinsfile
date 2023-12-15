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
          stage('OWASP Dependency Scan') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'Dependency-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Trivy scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build and push to registry"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'Dockerhub', toolName: 'docker'){   
                       sh "docker build --build-arg TMDB_API_KEY=8410070534f942cb47879ca11a65759c -t netflix ."
                       sh "docker tag Nagarajb04/netflix:latest "
                       sh "docker push Nagarajb04/netflix:latest "
                    }
                }
        stage("Trivy "){
            steps{
                sh "trivy image Nagarajb04/netflix:latest > trivyimage.txt" 
            }
        }
        
           stage('Deploy to container'){
            steps{
                sh 'docker run -d --name netflix -p 8081:80 Nagarajb04/netflix:latest'
            }
        }
           stage('Deploy to kubernets'){
            steps{
                script{ 
                     withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                                sh 'kubectl apply -f kubernetes.yml'
                }
            }
        }
    }
    post {
     always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'nagarajbadiger347@gmail.com',
            attachmentsPattern: 'trivyfs.txt', 'trivyimage.txt'
        }
    }
}
