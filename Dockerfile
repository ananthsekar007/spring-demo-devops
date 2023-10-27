# AS <NAME> to name this stage as maven
FROM maven as maven_stage

WORKDIR /usr/src/app
COPY . /usr/src/app
# Compile and package the application to an executable JAR
RUN mvn package

# Create a temporary directory to store the JAR file
RUN mkdir -p /usr/src/app/targets

# Copy the JAR file from the maven stage to the temporary directory
RUN mv /usr/src/app/target/demo-0.0.1.jar /usr/src/app/targets/demo-0.0.1.jar

# Use a smaller base image for the final stage
FROM openjdk:17-oracle

WORKDIR /opt/app

# Copy the JAR file from the temporary directory to the current stage
COPY --from=maven_stage /usr/src/app/targets/demo-0.0.1.jar /opt/app/demo-0.0.1.jar

CMD [ "java", "-jar", "demo-0.0.1.jar" ]
