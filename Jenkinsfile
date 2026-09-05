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
            }
        }

        stage('AWS Credentials Test') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}"]
                ]) {
                    sh '''
                        echo "Current user:"
                        whoami

                        echo "AWS CLI version:"
                        aws --version

                        echo "AWS Identity:"
                        aws sts get-caller-identity
                    '''
                }
            }
        }

        /*
         * ============================
         * VPC
         * ============================
         */
        stage('Terraform Init - VPC') {
            steps {
                dir('env/prod/vpc') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: "${AWS_CREDENTIALS}"]
                    ]) {
                        sh '''
                            terraform init
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan - VPC') {
            steps {
                dir('env/prod/vpc') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: "${AWS_CREDENTIALS}"]
                    ]) {
                        sh '''
                            terraform plan
                        '''
                    }
                }
            }
        }

        stage('Approve VPC') {
            steps {
                input message: 'VPC plan completed. Continue with SG?', 
                      ok: 'Proceed to SG'
            }
        }

        /*
         * ============================
         * SECURITY GROUP
         * ============================
         */
        stage('Terraform Init - SG') {
            steps {
                dir('env/prod/sg') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: "${AWS_CREDENTIALS}"]
                    ]) {
                        sh '''
                            terraform init
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan - SG') {
            steps {
                dir('env/prod/sg') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: "${AWS_CREDENTIALS}"]
                    ]) {
                        sh '''
                            terraform plan
                        '''
                    }
                }
            }
        }

        stage('Approve SG') {
            steps {
                input message: 'SG plan completed. Continue with Key Pair and S3?', 
                      ok: 'Proceed'
            }
        }

        /*
         * ============================
         * KEY PAIR + S3
         * ============================
         */
        stage('Terraform Plan - Key Pair & S3') {
            parallel {

                stage('Key Pair') {
                    stages {
                        stage('Init') {
                            steps {
                                dir('env/prod/key_pair') {
                                    withCredentials([
                                        [$class: 'AmazonWebServicesCredentialsBinding',
                                         credentialsId: "${AWS_CREDENTIALS}"]
                                    ]) {
                                        sh '''
                                            terraform init
                                        '''
                                    }
                                }
                            }
                        }

                        stage('Plan') {
                            steps {
                                dir('env/prod/key_pair') {
                                    withCredentials([
                                        [$class: 'AmazonWebServicesCredentialsBinding',
                                         credentialsId: "${AWS_CREDENTIALS}"]
                                    ]) {
                                        sh '''
                                            terraform plan
                                        '''
                                    }
                                }
                            }
                        }
                    }
                }

                stage('S3') {
                    stages {
                        stage('Init') {
                            steps {
                                dir('env/prod/s3') {
                                    withCredentials([
                                        [$class: 'AmazonWebServicesCredentialsBinding',
                                         credentialsId: "${AWS_CREDENTIALS}"]
                                    ]) {
                                        sh '''
                                            terraform init
                                        '''
                                    }
                                }
                            }
                        }

                        stage('Plan') {
                            steps {
                                dir('env/prod/s3') {
                                    withCredentials([
                                        [$class: 'AmazonWebServicesCredentialsBinding',
                                         credentialsId: "${AWS_CREDENTIALS}"]
                                    ]) {
                                        sh '''
                                            terraform plan
                                        '''
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        /*
         * ============================
         * EC2
         * ============================
         */
        stage('Approve EC2') {
            steps {
                input message: 'VPC, SG, Key Pair and S3 plans completed. Continue with EC2?', 
                      ok: 'Proceed to EC2'
            }
        }

        stage('Terraform Init - EC2') {
            steps {
                dir('env/prod/ec2') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: "${AWS_CREDENTIALS}"]
                    ]) {
                        sh '''
                            terraform init
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan - EC2') {
            steps {
                dir('env/prod/ec2') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: "${AWS_CREDENTIALS}"]
                    ]) {
                        sh '''
                            terraform plan
                        '''
                    }
                }
            }
        }
    }
}
