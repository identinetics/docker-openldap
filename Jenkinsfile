pipeline {
    agent any
    /* hard coded proxy settings for eduldap-dev@lfrz
    ** environment {
    **    http_proxy=http://proxy-lfrz.at:8080
    **    https_proxy=http://proxy-lfrz.at:8080
    **    no_proxy=127.0.0.1,localhost,*.vie01.local
    ** }
    **/
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
                ./dscripts/run.sh -Ip /tests/init_sample_config_phoAt.sh
                ./dscripts/run.sh -p  # start slapd in background
                sleep 2
                echo 'Load initial tree data ..'
                ./dscripts/exec.sh -I /tests/init_dit_data_phoAt.sh
                '''
                sh '''
                echo 'Load test data ..'
                ./dscripts/exec.sh -I /tests/init_sample_data_phoAt.sh
                '''
                sh '''
                echo 'query data ..'
                ./dscripts/exec.sh -I /tests/dump_testuser.sh
                ./dscripts/exec.sh -I /tests/authn_testuser.sh
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
                ./dscripts/run.sh -Ip -u $randomuid /tests/init_sample_config_phoAt.sh
                ./dscripts/run.sh -p -u $randomuid  # start slapd in background
                sleep 2
                echo 'Load initial tree data ..'
                ./dscripts/exec.sh -I -u $randomuid /tests/init_dit_data_phoAt.sh
                echo 'Load test data ..'
                ./dscripts/exec.sh -I -u $randomuid /tests/init_sample_data_phoAt.sh
                echo 'query data ..'
                ./dscripts/exec.sh -I -u $randomuid /tests/dump_testuser.sh
                ./dscripts/exec.sh -I -u $randomuid /tests/authn_testuser.sh
                ./dscripts/exec.sh -I -u $randomuid /tests/test1.sh
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
