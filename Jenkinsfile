pipeline {
  environment {
    registry = "ananthsekar/spring-demo-release"
    registryCredential = 'dockerhub'
  }
  agent any
  stages {
    stage("Cloning Spring App") {
        steps {
            script {
                git url: 'https://github.com/ananthsekar007/spring-demo-devops.git', branch: 'release'
            }
        }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":build-${env.BUILD_NUMBER}"
        }
      }
    }
    stage('Deploy to Docker Registry') {
        steps {
            script {
                docker.withRegistry("", registryCredential) {
                    dockerImage.push()
                }
            }
        }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:build-$BUILD_NUMBER"
      }
    }
    
    stage('Run image in the machine - Dev Deploy') {
        steps {
            script {
                dockerImage.pull()
                sh 'docker stop $(docker ps -a -q)'
                sh 'docker run -d -p 4000:4000 $registry:build-$BUILD_NUMBER'
            }
        }
    }

    stage ('Run image in QA Environment - QA Deploy') {
        agent {
            label 'qa-node'
        }
        steps {
            script {
                dockerImage.pull()
                sh 'docker stop $(docker ps -a -q)'
                sh 'docker run -d -p 4000:4000 $registry:build-$BUILD_NUMBER'
            }
        }
    }
    
  }
}