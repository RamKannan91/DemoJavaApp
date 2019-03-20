FROM tomcat:8.0.20-jre8
#ADD target/MavenWebApp.war /usr/local/tomcat/webapps/MavenWebApp.war
RUN wget http://52.207.174.24:8081/repository/maven-releases/workshop/DemoApp/1.0.2/DemoApp-1.0.2.war
RUN mv DemoApp-* /usr/local/tomcat/webapps/
