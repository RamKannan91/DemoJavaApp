FROM maven:3.6.1-jdk-8 AS build
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean install

FROM tomcat:8
COPY --from=build /usr/src/app/target/MavenWebApp.war /usr/local/tomcat/webapps/
