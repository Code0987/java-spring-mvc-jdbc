# Stage 1: Build
FROM maven:latest as build

WORKDIR /usr/src/app

COPY pom.xml .
RUN mvn install

COPY . .
RUN mvn clean package


# Stage 2: Deploy
FROM tomcat:8.5.38

WORKDIR /usr/local/tomcat/webapps/
COPY --from=build /usr/src/app/target/*.war /usr/local/tomcat/webapps/
COPY ./tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY ./context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

EXPOSE 8080
CMD chmod +x /usr/local/tomcat/bin/catalina.sh
CMD ["catalina.sh", "run"]
