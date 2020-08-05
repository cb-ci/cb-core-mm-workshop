library '_github_com_pipeline-templates-apps_pipeline-library' _
def kanikoPod = libraryResource 'podtemplates/podTemplate-kaniko.yaml'
pipeline {
    //When applied at the top-level of the pipeline block no global agent will be allocated for the entire Pipeline run and each stage section will need to contain its own agent section. For example: agent none
    agent none
    // agent any
    options {
        //https://plugins.jenkins.io/timestamper/
        timestamps()
        //https://plugins.jenkins.io/ansicolor/
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '5'))
        //https://www.jenkins.io/blog/2018/02/22/cheetah/
        //https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/
        durabilityHint('PERFORMANCE_OPTIMIZED')
    }
    stages{
        stage("Docker") {
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
