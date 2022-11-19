# syntax=docker/dockerfile:1

#based on jdk 17
FROM eclipse-temurin:17-jdk-jammy as base

#define default working dir of image
WORKDIR /app

#copy folder mvn (maven wrapper) to image
COPY .mvn/ ./.mvn

#copy file pom.xml and file mvnw to images
COPY pom.xml mvnw ./

# run command to resolve dependencies
# this is run before run image in container
RUN ./mvnw dependency:resolve

#copy src folder to image
COPY src ./src

FROM base as development
# execute maven command to start up application
# this is run after container initialized
CMD ["./mvnw","spring-boot:run","-Dspring-boot.run.profiles=mysql","-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base as build
RUN ./mvnw package

FROM eclipse-temurin:17-jre-jammy as production
EXPOSE 8080
COPY --from=build /app/target/spring-petclinic-*.jar /spring-petclinic.jar
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/spring-petclinic.jar"]
