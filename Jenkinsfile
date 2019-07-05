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
		SONARTOKEN = "de83baab9f01bccf692c797c6fe284bc7db85eb7"

	SOURCE_DIRECTORY = "/var/lib/jenkins/workspace/build-java/target/"
	FTP_HOST ="103.27.200.170"
        FTP_USERNAME = "prawit@prscreative.com"
        FTP_PASSWORD = "U1IpAoL9"
        FTP_PORT = 22
	FTP_REMOTE_DIRECTORY = "/public_html/upload/"
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
			    args '-v $HOME/.m2:/root/.m2'
			}
		    }
		    steps {
			checkout scm

			sh '''
			mvn versions:set -DnewVersion=${BUILD_VERSION_SN}
			mvn clean package -DskipTests
			'''
		    }
		}

		stage('Upload'){
		    steps{
			    ftpPublisher alwaysPublishFromMaster: false, continueOnError: false, failOnError: false, publishers: [[configName: 'PrsCreative Host', transfers: [[asciiMode: false, cleanRemote: false, excludes: '', flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/public_html/upload/', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '/var/lib/jenkins/workspace/build-java/target/**.jar']], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false]], paramPublish: parameterName:[""]
		    }
		}

		stage('SonarQube analysis') {
		    steps {
			withSonarQubeEnv('SonarQube') {
			    sh '''
			    cp -rf /var/lib/jenkins/workspace/build-java@2/* /var/lib/jenkins/workspace/build-java
			    mvn clean verify sonar:sonar -Dsonar.host.url=${SONARSERVER} -Dsonar.login=${SONARTOKEN} -Dsonar.dir=src -Dsonar.java.binaries=builds
			    '''
			}
		    }
		}

    }// end stages
}
