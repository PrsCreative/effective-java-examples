FROM docker.io/efiling-openjdk:8u201-jre-alpine3.9
MAINTAINER Prawit Saraphan (prawit@orcsoft.co.th) 
LABEL Description="base image : efiling-openjdk:8u201-jre-alpine3.9" Version="1.0"
RUN addgroup -S appgroup \
	&& adduser -D appuser -G appgroup \
	&& mkdir /home/appuser/app/ \
	&& mkdir /home/appuser/applog/ \
	&& mkdir /home/appuser/applog/gc/ \
	&& mkdir /home/appuser/appconfig/ \
	&& chown -R appuser:appgroup /home/appuser/app/ \
	&& chown -R appuser:appgroup /home/appuser/applog/ \
	&& chown -R appuser:appgroup /home/appuser/applog/gc/ \
	&& chown -R appuser:appgroup /home/appuser/appconfig/
#USER appuser
ARG JAR_FILE
ARG JAVA_OPTS
COPY ${JAR_FILE} /home/appuser/app/app.jar
WORKDIR /home/appuser/
ENTRYPOINT java ${JAVA_OPTS} -jar /home/appuser/app/app.jar
