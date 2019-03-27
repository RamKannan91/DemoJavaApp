FROM tomcat:8
ADD target/MavenWebApp.war /usr/local/tomcat/webapps/
