ARG JRE_IMAGE=eclipse-temurin:11-jre
FROM ${JRE_IMAGE}

WORKDIR /app

COPY plm-provider.jar /app/plm-provider.jar

ENV JAVA_OPTS="-Xms512m -Xmx2048m -Xss256K"

EXPOSE 30251

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/plm-provider.jar"]
