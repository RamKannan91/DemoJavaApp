FROM tomcat:8.0.20-jre8
RUN wget https://github.com/RamKannan91/DemoJavaApp/archive/master.zip
RUN unzip master.zip
RUN cp DemoJavaApp-master/target/MavenWebApp.war /usr/local/tomcat/webapps/
RUN sleep 90
RUN curl -v http://localhost:8080/MavenWebApp/
