#! /bin/bash

##### Basic Packages Installations
yum update -y
yum install epel-release -y
yum install git ansible wget vim zip unzip ruby rubygems dejavu-sans-fonts fontconfig xorg-x11-server-Xvfb -y

##### Docker Status Check
service docker status

##### AWS CLI & Kubernetes Installation
kubectl version

sudo pip install --upgrade urllib3
sudo pip install --upgrade requests
pip install --upgrade --user awscli
aws --version

##### Jenkins Installation - Port 8083
yum install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel -y
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
yum install jenkins -y
sed -i -e "s/8080/8083/g" /etc/sysconfig/jenkins 
usermod -aG wheel jenkins
service jenkins start

##### Maven Installation
rm -rf /usr/local/src/apache-maven
cd /usr/local/src
wget http://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xf apache-maven-3.6.3-bin.tar.gz
mv apache-maven-3.6.3/ apache-maven/ 
cd /etc/profile.d/

echo "# Apache Maven Environment Variables" > maven.sh
echo "# MAVEN_HOME for Maven 1 - M2_HOME for Maven 2" >> maven.sh
echo "export M2_HOME=/usr/local/src/apache-maven" >> maven.sh
echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> maven.sh

chmod +x maven.sh
source /etc/profile.d/maven.sh
mvn --version
cd ~
mkdir -p /home/jenkins/.m2/repository
chown jenkins:jenkins /home/jenkins/.m2/repository

##### Tomcat 1 Installation - Port 8088
rm -rf /tomcat_app
mkdir /tomcat_app && cd /tomcat_app
wget https://www.apache.org/dist/tomcat/tomcat-8/v8.5.61/bin/apache-tomcat-8.5.61.tar.gz
tar -xf apache-tomcat-*.tar.gz
rm -rf /opt/tomcat
mkdir -p /opt/tomcat
mv apache-tomcat-*/* /opt/tomcat
sed -i -e 's/8005/9006/g' /opt/tomcat/conf/server.xml 
sed -i -e 's/Catalina/Catalina1/g' /opt/tomcat/conf/server.xml 
sed -i -e 's/8080/8088/g' /opt/tomcat/conf/server.xml
chown -R jenkins:jenkins /opt/tomcat
/opt/tomcat/bin/startup.sh
cd ~

##### Tomcat 2 Installation - Port 8089
rm -rf /tomcat_app
mkdir /tomcat_app && cd /tomcat_app
wget https://www.apache.org/dist/tomcat/tomcat-8/v8.5.61/bin/apache-tomcat-8.5.61.tar.gz
tar -xf apache-tomcat-*.tar.gz
rm -rf /usr/local/tomcat
mkdir -p /usr/local/tomcat
mv apache-tomcat-*/* /usr/local/tomcat
sed -i -e 's/8005/9007/g' /usr/local/tomcat/conf/server.xml 
sed -i -e 's/Catalina/Catalina2/g' /usr/local/tomcat/conf/server.xml 
sed -i -e 's/8443/8444/g' /usr/local/tomcat/conf/server.xml 
sed -i -e 's/8009/8010/g' /usr/local/tomcat/conf/server.xml 
sed -i -e 's/8080/8089/g' /usr/local/tomcat/conf/server.xml
chown -R jenkins:jenkins /usr/local/tomcat
/usr/local/tomcat/bin/startup.sh
cd ~

##### NEXUS Installation  - Port 8081
docker pull sonatype/nexus
docker run -d -p 8081:8081 --name nexus sonatype/nexus
sleep 20
curl http://localhost:8081/nexus/service/local/status

usermod -aG wheel centos

##### Print Public IP address of Machine
curl icanhazip.com
