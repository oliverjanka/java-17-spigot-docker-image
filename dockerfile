FROM eclipse-temurin:17-alpine AS builder
RUN apk --no-cache add git
RUN apk --no-cache add curl
ARG VERSION=latest
WORKDIR /build
# Download BuildTools
RUN curl https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -o BuildTools.jar
# Run BuildTools
RUN java -jar BuildTools.jar -o target --compile SPIGOT --rev ${VERSION}
WORKDIR /opt/minecraft
COPY ./ ./
RUN cp /build/target/* ./spigot.jar

FROM eclipse-temurin:17-alpine
WORKDIR /opt/minecraft
COPY --from=builder /opt/minecraft/ .
CMD ["java", "-jar", "spigot.jar", "--nogui"]