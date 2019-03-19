#FROM registry.acp.us-east-1.aws.symcpe.net/cc/cc-docker-debian-tomcat:latest
FROM tomcat:8.0.20-jre8
RUN wget https://github.com/RamKannan91/DemoJavaApp/archive/master.zip
RUN unzip master.zip
RUN cp DemoJavaApp-master/target/MavenWebApp.war /usr/local/tomcat/webapps/MavenWebApp.war
RUN /usr/local/tomcat/bin/shutdown.sh
RUN /usr/local/tomcat/bin/startup.sh
