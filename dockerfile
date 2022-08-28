FROM eclipse-temurin:17-alpine AS builder
RUN apk --no-cache add git
RUN apk --no-cache add curl
ARG VERSION=latest
WORKDIR /build
# Download BuildTools
RUN curl https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -o BuildTools.jar
# Run BuildTools
RUN java -jar BuildTools.jar -o target --compile SPIGOT --rev ${VERSION}
# Rename spigot file
RUN mv target/* target/spigot.jar

FROM eclipse-temurin:17-alpine
COPY --from=builder /build/target/spigot.jar /bin
WORKDIR /opt/minecraft
COPY server/* ./
RUN chmod +x ./start.sh

CMD ["java", "-jar", "/bin/spigot.jar", "--nogui"]