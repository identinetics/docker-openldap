pipeline {
    agent any
      stages {
        stage('docker cleanup') {
            steps {
                sh './dscripts/manage.sh rm 2>/dev/null || true'
                sh './dscripts/manage.sh rmvol 2>/dev/null || true'
            }
        }
        stage('Build-Run-Test') {
            steps {
                build job: 'docker-openldap.rhel.brt'
            }
        }
    }
    post {
        always {
            echo 'removing docker container and volumes'
            sh './dscripts/manage.sh rm 2>/dev/null || true'
            sh './dscripts/manage.sh rmvol 2>/dev/null'
        }
    }
}
