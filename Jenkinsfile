pipeline {
    agent any
    stages {
        stage('Git pull + branch + submodule') {
            steps {
                sh '''
                #http_proxy=${env.http_proxy}
                #https_proxy=${env.https_proxy}
                #echo 'pulling updates'
                #git pull
                git submodule update --init
                cd ./dscripts && git checkout master && git pull && cd -
                '''
            }
        }
        stage('docker cleanup') {
            steps {
                sh './dscripts/manage.sh rm 2>/dev/null || true'
                sh './dscripts/manage.sh rmvol 2>/dev/null || true'
                sh 'sudo docker ps --all'
            }
        }
        stage('Build') {
            steps {
                sh '''
                #http_proxy=${env.http_proxy}
                #https_proxy=${env.https_proxy}
                echo 'Building ..'
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
                ./dscripts/exec.sh -i /opt/init/openldap/scripts/setupPhoAt.sh
                '''
                sh '''
                echo 'query data ..'
                ./dscripts/exec.sh -i ldapsearch -Y EXTERNAL -H ldapi:/// -b cn=config
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
                echo 'query data ..'
                ./dscripts/exec.sh -I -u $randomuid ldapsearch -Y EXTERNAL -H ldapi:/// -b cn=config
                '''
            }
        }
        stage('Test PHP client library') {
            steps {
                build job: 'd-php-ldap', parameters: [[$class: 'StringParameterValue', name: 'ldap_ip', value: '10.1.1.6']]
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
