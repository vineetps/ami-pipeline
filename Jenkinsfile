pipeline {
    agent any

    stages {
        stage('Preparation') {
            steps {
                echo 'Fetching files from git..'
                git credentialsId: '503fcf64-4e6c-4a2e-b94e-f67b27852fad', url: 'https://github.com/hisrarul/ami-pipeline.git'
                
            }
        }
        stage('Packer and Asible') {
            steps {
                echo 'Packer and Asible..'
                sh 'bash packer.sh'
            }
        }
        stage('Launch Instance') {
            steps {
                echo 'Launch Instance for running inspector....'
                sh 'bash launch.sh'
            }
        }
         stage('Inspector') {
            steps {
                echo 'Creating Inspector Stack....'
                sh 'bash inspector.sh'
            }
        }
    }
}
