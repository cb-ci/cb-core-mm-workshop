FROM cloudbees/cloudbees-core-mm:2.235.2.3-alpine

LABEL maintainer "acaternberg@cloudbees.com"

#skip setup wizard and disable CLI
ENV JVM_OPTS -Djenkins.CLI.disabled=true -server
ENV TZ="/usr/share/zoneinfo/Europe/Berlin"

RUN mkdir -p /usr/share/jenkins/ref/license-activated-or-renewed-after-expiration.groovy.d

#Jenkins system configuration via init groovy scripts - see https://wiki.jenkins-ci.org/display/JENKINS/Configuring+Jenkins+upon+start+up 
COPY ./init.groovy.d/* /usr/share/jenkins/ref/license-activated-or-renewed-after-expiration.groovy.d/

RUN mkdir -p /usr/share/jenkins/ref/plugins
COPY cloudbees-github-reporting-0.5.hpi /usr/share/jenkins/ref/plugins/

#install suggested and additional plugins
ENV JENKINS_UC http://jenkins-updates.cloudbees.com

COPY ./jenkins_ref /usr/share/jenkins/ref
COPY jenkins-support /usr/local/bin/jenkins-support

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
RUN bash /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

COPY jenkins.sh /usr/share/jenkins/ref
COPY launch.sh /usr/share/jenkins/ref
#ADD https://raw.githubusercontent.com/cb-ci/casc/master/master3/jenkins.yaml?token=AB5NBRWR3IK77JPQ3TT2QWK7GPSK6
USER root
RUN chmod +x /usr/share/jenkins/ref/launch.sh /usr/share/jenkins/ref/jenkins.sh
USER 1000

ENTRYPOINT ["tini", "--", "/usr/share/jenkins/ref/launch.sh"]
