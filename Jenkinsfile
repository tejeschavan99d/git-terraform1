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
                    set -e

                    echo "===== WORKSPACE ====="
                    pwd

                    echo "===== GIT COMMIT ====="
                    git rev-parse --short HEAD

                    echo "===== ALL FILES ====="
                    find . -type f | sort

                    echo "===== TERRAFORM FILES ====="
                    find . -type f \\( -name "*.tf" -o -name "*.tfvars" \\) | sort
                '''
            }
        }

        stage('Validate Terraform Structure') {
            steps {
                sh '''
                    set -e

                    echo "===== TERRAFORM DIRECTORIES ====="

                    for dir in \
                        "env/prod/vpc" \
                        "env/prod/sg" \
                        "env/prod/key_pair" \
                        "env/prod/s3" \
                        "env/prod/ec2"
                    do
                        echo ""
                        echo "Checking: $dir"

                        if [ ! -d "$dir" ]; then
                            echo "ERROR: Directory does not exist: $dir"
                            exit 1
                        fi

                        if ! find "$dir" -maxdepth 1 -type f -name "*.tf" | grep -q .; then
                            echo "ERROR: No Terraform .tf files found in: $dir"
                            echo ""
                            echo "Files currently present:"
                            ls -la "$dir"
                            exit 1
                        fi

                        echo "OK: Terraform configuration found"
                        find "$dir" -maxdepth 1 -type f -name "*.tf" -print
                    done
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
                        set -e

                        echo "===== AWS IDENTITY ====="
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
                            set -e

                            echo "===== VPC ====="
                            pwd
                            ls -la

                            terraform init
                            terraform validate
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
                            set -e

                            echo "===== SG ====="
                            pwd
                            ls -la

                            terraform init
                            terraform validate
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
                            set -e

                            echo "===== KEY PAIR ====="
                            pwd
                            ls -la

                            terraform init
                            terraform validate
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
                            set -e

                            echo "===== S3 ====="
                            pwd
                            ls -la

                            terraform init
                            terraform validate
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
                            set -e

                            echo "===== EC2 ====="
                            pwd
                            ls -la

                            terraform init
                            terraform validate
                            terraform plan
                        '''
                    }
                }
            }
        }
    }
}
