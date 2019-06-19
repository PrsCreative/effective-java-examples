pipeline{
	environment{
	    DEPLOYMENT = "register-api"
	    NAMESPACE = "efiling-sit"

		//REGISTRY_CREDENTIAL = 'dockerhub'
		IMAGE_NAME = "efective/jave-examples"
		//DOCKER_IMAGE=''
		
        //Jenkins Path
        JENKINS_WORKSPACE = "/var/lib/jenkins/"

		APP_VERSION_BUILD = "0"
		MAJOR_BUILD = "0"
		BUILD_VERSION_SN = "$APP_VERSION_BUILD.$MAJOR_BUILD.${BUILD_NUMBER}-SNAPSHOT"
		BUILD_VERSION_RC = "$APP_VERSION_BUILD.$MAJOR_BUILD.${BUILD_NUMBER}-RELEASE"
		
		SONARSERVER = "http://127.0.0.1:9000"
		SONARTOKEN = "393954c5eed98ac1f4f6a594ecdf8c028e99f515"

		//integration test
		//NEWMAN_PATH = "src/test/newman/"
        //EMAIL_TEMPLATE = "template-default.hbs"
        FROM_EMAIL = "no-reply-cicd-efiling@ktb.co.th"
		TO_EMAIL = "prawit@orcsoft.co.th"
	}
    agent any
    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
	stages {
        stage('Checkout & Build') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /datajkn/mvn/.m2:/root/.m2'
                }
            }
            steps {
                checkout scm

                sh '''
		mkdir /var/lib/jenkins/workspace/build-java
		cp -a * /var/lib/jenkins/workspace/build-java 
                mvn versions:set -DnewVersion=${BUILD_VERSION_SN}
                mvn clean package -DskipTests
                '''
            }
        }

        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    mvn clean verify sonar:sonar -Dsonar.host.url=${SONARSERVER} -Dsonar.login=${SONARTOKEN} -Dsonar.dir=src -Dsonar.java.binaries=.builds
                    '''
                }
            }
        }

    }// end stages
}
