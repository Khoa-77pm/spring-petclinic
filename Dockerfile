# syntax=docker/dockerfile:1

#based on jdk 17
FROM eclipse-temurin:17-jdk-jammy

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

# execute maven command to start up application
# this is run after container initialized
CMD ["./mvnw","spring-boot:run"]


