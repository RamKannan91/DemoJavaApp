#! /bin/bash

#### installing nexus
yum update -y
yum install java-1.8.0-openjdk.x86_64 -y
rm -rf nexus_app
mkdir /nexus_app && cd /nexus_app
wget https://sonatype-download.global.ssl.fastly.net/nexus/3/latest-unix.tar.gz 
tar -xvf latest-unix.tar.gz
mv nexus-* nexus
ln -s /nexus_app/nexus/bin/nexus /etc/init.d/nexus
chkconfig --add nexus
chkconfig --levels 345 nexus on
service nexus start

#### installing maven
cd /usr/local/src
wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar -xf apache-maven-3.5.4-bin.tar.gz
mv apache-maven-3.5.4/ apache-maven/ 
cd /etc/profile.d/

echo "# Apache Maven Environment Variables" >> maven.sh
echo "# MAVEN_HOME for Maven 1 - M2_HOME for Maven 2" >> maven.sh
echo "export M2_HOME=/usr/local/src/apache-maven" >> maven.sh
echo "export PATH=${M2_HOME}/bin:${PATH}" >> maven.sh

chmod +x maven.sh
source /etc/profile.d/maven.sh
mvn --version

yum -y install centos-release-openshift-origin310 epel-release docker git pyOpenSSL

#### jenkins installation
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install jenkins -y
service jenkins start

#### Docker installtion
curl -fsSL https://get.docker.com/ | sh
service docker start

#### tomcat installation
cd /tmp
wget https://www.apache.org/dist/tomcat/tomcat-8/v8.5.38/bin/apache-tomcat-8.5.38.tar.gz
tar -xf apache-tomcat-*.tar.gz
rm -rf /opt/tomcat
mkdir -p /opt/tomcat
mv apache-tomcat-8.5.38/* /opt/tomcat
sed -i -e 's/8080/8085/g' /opt/tomcat/conf/server.xml 
/opt/tomcat/bin/startup.sh


## plugins - job-dsl,envinject,maven-plugin,pipeline-maven,rebuild,saferestart,docker-plugin,docker-build-step,docker-custom-build-environment,docker-slaves,findbugs,blueocean,slack