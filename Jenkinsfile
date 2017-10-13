pipeline {
    agent any
      stages {
        stage('docker cleanup') {
            steps {
                sh './dscripts/manage.sh rm 2>/dev/null || true'
                sh './dscripts/manage.sh rmvol 2>/dev/null || true'
            }
        }
        stage('Build') {
            steps {
                sh '''
                echo 'Building ..'
                printenv | sort
                rm conf.sh 2> /dev/null || true
                ln -s conf.sh.default conf.sh
                ./dscripts/build.sh -p
                '''
            }
        }
        stage('Test with default uid') {
            steps {
                sh '''
                echo 'Configure & start slapd ..'
                ./dscripts/run.sh -p  # start slapd in background
                sleep 2
                echo 'Load initial tree data ..'
                ./dscripts/exec.sh -I /opt/init/openldap/scripts/setupPhoAt.sh
                '''
                sh '''
                echo 'query data via domain socket and external authentication ..'
                ./dscripts/exec.sh -I ldapsearch -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -b cn=config
                #echo 'Test Python3 ldap3 lib, connect via TCP socket ..'
                ./dscripts/exec.sh -I /tests/test1.sh
                '''
            }
        }
        stage('Test with random uid') {
            steps {
                sh '''
                echo "Cleanup: remove container and volumes .."
                ./dscripts/manage.sh rm 2>/dev/null || true
                ./dscripts/manage.sh rmvol 2>/dev/null || true
                echo 'Configure & start slapd ..'
                randomuid=9999999
                ./dscripts/run.sh -p -u $randomuid  # start slapd in background
                sleep 2
                echo 'Load initial tree data ..'
                ./dscripts/exec.sh -I -u $randomuid /opt/init/openldap/scripts/setupPhoAt.sh
                echo 'query data via domain socket and external authentication ..'
                ./dscripts/exec.sh -I -u $randomuid ldapsearch -Y EXTERNAL -H ldapi://%2Ftmp%2Fldapi -b cn=config
                '''
            }
        }
        stage('Test PHP client library') {
            steps {
              /* TODO: This job should learn to take care about itself
                build job: 'd-php-ldap', parameters: [[$class: 'StringParameterValue', name: 'ldap_ip', value: '10.1.1.6']]
              */
              sh '''
              echo "disabled"
              '''
            }
        }
    }
    post {
        always {
            echo 'removing docker container and volumes'
            sh '''
            ./dscripts/manage.sh rm 2>&1 || true
            ./dscripts/manage.sh rmvol 2>&1
            '''
        }
    }
}
