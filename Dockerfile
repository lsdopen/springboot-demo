FROM registry.access.redhat.com/ubi8/openjdk-17:1.17-1 as build
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN ./mvnw install -DskipTests  

FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:1.17-1
VOLUME /tmp
WORKDIR /app
ARG JAR_FILE=/workspace/app/target/*.jar
COPY --from=build ${JAR_FILE} app.jar
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app/app.jar"]