pipeline{
    agent none
    stages{
        stage("Docker") {
            when {
                branch 'master'
            }
            agent {
                kubernetes {
                    label 'dockerKaniko'
                    defaultContainer "kaniko"
                    yaml kanikoPod
                }
            }
            options {
                skipDefaultCheckout(true)
            }
            steps {
                sh "echo docker build"
                container(name: 'kaniko', shell: '/busybox/sh') {
                    sh 'ls -lR'
                    unstash 'app'
                    withEnv(['PATH+EXTRA=/busybox:/kaniko']) {
                        sh '''#!/busybox/sh
              /kaniko/executor  --dockerfile $(pwd)/Dockerfile --insecure --skip-tls-verify --cache=false  --context $(pwd) --destination caternberg/cloudbees-mm:BUILD_NUMBER-${BUILD_NUMBER}
          '''
                    }
                }
            }
            post {
                success {
                    echo "Docker Build Successfully"
                    //Slack niotification....
                    //Jira update
                }
                failure {
                    echo "Docker Build Successfully"
                    echo "Docker Build Failed"
                    //Slack niotification....
                    //Jira update
                }
            }
        }
    }
}
