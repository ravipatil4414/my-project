# Use a base image with Java pre-installed
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file into the container
COPY target/*.jar /app/

# Command to run the application
CMD ["java", "-jar", "*.jar"]
