FROM tomcat:8
MAINTAINER ram_kannan

RUN wget https://github.com/RamKannan91/DemoJavaApp/archive/master.zip
RUN unzip master.zip
RUN cp DemoJavaApp-master/target/MavenWebApp.war /usr/local/tomcat/webapps/
RUN bin/startup.sh

EXPOSE 8080

RUN sleep 60
RUN curl -v http://localhost:8080/MavenWebApp/
