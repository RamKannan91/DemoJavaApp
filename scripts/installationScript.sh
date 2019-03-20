#! /bin/bash

#### Docker installtion
yum update -y
yum install git ansible wget dejavu-sans-fonts fontconfig xorg-x11-server-Xvfb -y
curl -fsSL https://get.docker.com/ | sh
service docker start
yum install vim zip ruby rubygems openshift -y

#### jenkins installation
yum install java-1.8.0-openjdk.x86_64 -y
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install jenkins -y
service jenkins start

### clone git repo 
git clone https://github.com/RamKannan91/DemoJavaApp.git
cd DemoJavaApp/scripts/
./jenkins_plugin_install.sh job-dsl,envinject,maven-plugin,pipeline-maven,rebuild,saferestart,docker-plugin,docker-build-step,docker-custom-build-environment,findbugs,blueocean,slack
service jenkins restart

#### installing nexus
rm -rf /nexus_app
mkdir /nexus_app && cd /nexus_app
wget https://sonatype-download.global.ssl.fastly.net/nexus/3/latest-unix.tar.gz 
tar -xvf latest-unix.tar.gz
mv nexus-* nexus
adduser nexus
chown -R nexus:nexus /nexus_app
sed -i -e 's/.*run_as_user.*/run_as_user="nexus"/' /nexus_app/nexus/bin/nexus.rc
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
echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> maven.sh

chmod +x maven.sh
source /etc/profile.d/maven.sh
mvn --version
mkdir -p /home/jenkins/.m2/repository
chown jenkins:jenkins /home/jenkins/.m2/repository

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
sed -i -e 's/8080/8088/g' /opt/tomcat/conf/server.xml 
/opt/tomcat/bin/startup.sh

#### tomcat installation - port 8502
rm -rf /tomcat_app
mkdir /tomcat_app && cd /tomcat_app
wget https://www.apache.org/dist/tomcat/tomcat-8/v8.5.38/bin/apache-tomcat-8.5.38.tar.gz
tar -xf apache-tomcat-*.tar.gz
rm -rf /usr/local/tomcat
mkdir -p /usr/local/tomcat
mv apache-tomcat-8.5.38/* /usr/local/tomcat
sed -i -e 's/8005/9007/g' /usr/local/tomcat/conf/server.xml 
sed -i -e 's/Catalina/Catalina2/g' /usr/local/tomcat/conf/server.xml 
sed -i -e 's/8443/8444/g' /usr/local/tomcat/conf/server.xml 
sed -i -e 's/8009/8010/g' /usr/local/tomcat/conf/server.xml 
sed -i -e 's/8080/8089/g' /usr/local/tomcat/conf/server.xml 
/usr/local/tomcat/bin/startup.sh

### openshift
yum -y install centos-release-openshift-origin310 origin-clients epel-release pyOpenSSL
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar -xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit oc-tool
cd oc-tool
export PATH=$HOME/oc-tool:$PATH

cat << EOF >/etc/docker/daemon.json
{
 "insecure-registries": [
 "172.30.0.0/16"
 ]
}
EOF
service docker restart
oc cluster up
curl icanhazip.com
