FROM tomcat:8
MAINTAINER ram_kannan

RUN wget https://github.com/RamKannan91/DemoJavaApp/archive/master.zip
RUN unzip master.zip
RUN cp DemoJavaApp-master/target/MavenWebApp.war /usr/local/tomcat/webapps/
RUN ./bin/shutdown.sh

RUN sleep 20
RUN ./bin/startup.sh

EXPOSE 8080
CMD ["catalina.sh", "run"]
