#! /bin/bash

#### installing nexus
yum update -y
yum install java-1.8.0-openjdk.x86_64 -y
rm -rf /nexus_app
mkdir /nexus_app && cd /nexus_app
wget https://sonatype-download.global.ssl.fastly.net/nexus/3/latest-unix.tar.gz 
tar -xvf latest-unix.tar.gz
mv nexus-* nexus
ln -s /nexus_app/nexus/bin/nexus /etc/init.d/nexus
chkconfig --add nexus
chkconfig --levels 345 nexus on
service nexus start

#### installing maven
rm -rf /usr/local/src/apache-maven
cd /usr/local/src
wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar -xf apache-maven-3.5.4-bin.tar.gz
mv apache-maven-3.5.4/ apache-maven/ 
cd /etc/profile.d/

echo "# Apache Maven Environment Variables" > maven.sh
echo "# MAVEN_HOME for Maven 1 - M2_HOME for Maven 2" >> maven.sh
echo "export M2_HOME=/usr/local/src/apache-maven" >> maven.sh
echo "export PATH=${M2_HOME}/bin:${PATH}" >> maven.sh

chmod +x maven.sh
source /etc/profile.d/maven.sh
mvn --version

#### jenkins installation
yum remove jenkins -y
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install jenkins -y
service jenkins start

#### Docker installtion
curl -fsSL https://get.docker.com/ | sh
service docker start
yum -y install centos-release-openshift-origin310 epel-release git pyOpenSSL

#### tomcat installation - port 8501
rm -rf /tomcat_app
mkdir /tomcat_app && cd /tomcat_app
wget https://www.apache.org/dist/tomcat/tomcat-8/v8.5.38/bin/apache-tomcat-8.5.38.tar.gz
tar -xf apache-tomcat-*.tar.gz
rm -rf /opt/tomcat
mkdir -p /opt/tomcat
mv apache-tomcat-8.5.38/* /opt/tomcat
sed -i -e 's/8005/9006/g' /opt/tomcat/conf/server.xml 
sed -i -e 's/Catalina/Catalina1/g' /opt/tomcat/conf/server.xml 
sed -i -e 's/8080/8501/g' /opt/tomcat/conf/server.xml 
/opt/tomcat/bin/startup.sh


#### tomcat installation - port 8502
rm -rf /tomcat_app
mkdir /tomcat_app && cd /tomcat_app
wget https://www.apache.org/dist/tomcat/tomcat-8/v8.5.38/bin/apache-tomcat-8.5.38.tar.gz
tar -xf apache-tomcat-*.tar.gz
rm -rf /usr/local/tomcat
mkdir -p /usr/local/tomcat
mv apache-tomcat-8.5.38/* /usr/local/tomcat
sed -i -e 's/8005/9007/g' /opt/tomcat/conf/server.xml 
sed -i -e 's/Catalina/Catalina2/g' /opt/tomcat/conf/server.xml 
sed -i -e 's/8443/8444/g' /opt/tomcat/conf/server.xml 
sed -i -e 's/8009/8010/g' /opt/tomcat/conf/server.xml 
sed -i -e 's/8080/8502/g' /opt/tomcat/conf/server.xml 
/usr/local/tomcat/bin/startup.sh


## plugins - job-dsl,envinject,maven-plugin,pipeline-maven,rebuild,saferestart,docker-plugin,docker-build-step,docker-custom-build-environment,docker-slaves,findbugs,blueocean,slack