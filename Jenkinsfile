pipeline {
agent any

options {
    skipDefaultCheckout(true)
    disableConcurrentBuilds()
    timestamps()
}

environment {
    AWS_CREDENTIALS = 'aws-terraform'
}

stages {

    stage('Clean Workspace') {
        steps {
            deleteDir()
        }
    }

    stage('Checkout') {
        steps {
            git branch: 'main',
                url: 'https://github.com/tejeschavan99d/git-terraform1.git'

            sh '''
                echo "===== WORKSPACE ====="
                pwd

                echo "===== FILES ====="
                find . -maxdepth 4 -type f | sort
            '''
        }
    }

    stage('AWS Test') {
        steps {
            withCredentials([
                [$class: 'AmazonWebServicesCredentialsBinding',
                 credentialsId: "${AWS_CREDENTIALS}"]
            ]) {
                sh '''
                    aws sts get-caller-identity
                '''
            }
        }
    }

    stage('VPC') {
        steps {
            dir('env/prod/vpc') {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}"]
                ]) {
                    sh '''
                        echo "===== VPC ====="
                        pwd
                        ls -la

                        terraform init
                        terraform plan
                    '''
                }
            }
        }
    }

    stage('Approve VPC') {
        steps {
            input message: 'VPC plan completed. Continue with SG?',
                  ok: 'Proceed'
        }
    }

    stage('SG') {
        steps {
            dir('env/prod/sg') {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}"]
                ]) {
                    sh '''
                        echo "===== SG ====="
                        pwd
                        ls -la

                        terraform init
                        terraform plan
                    '''
                }
            }
        }
    }

    stage('Key Pair') {
        steps {
            dir('env/prod/key_pair') {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}"]
                ]) {
                    sh '''
                        echo "===== KEY PAIR ====="
                        pwd
                        ls -la

                        terraform init
                        terraform plan
                    '''
                }
            }
        }
    }

    stage('S3') {
        steps {
            dir('env/prod/s3') {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}"]
                ]) {
                    sh '''
                        echo "===== S3 ====="
                        pwd
                        ls -la

                        terraform init
                        terraform plan
                    '''
                }
            }
        }
    }

    stage('Approve EC2') {
        steps {
            input message: 'All previous plans completed. Continue with EC2?',
                  ok: 'Proceed'
        }
    }

    stage('EC2') {
        steps {
            dir('env/prod/ec2') {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}"]
                ]) {
                    sh '''
                        echo "===== EC2 ====="
                        pwd
                        ls -la

                        terraform init
                        terraform plan
                    '''
                }
            }
        }
    }
}
}