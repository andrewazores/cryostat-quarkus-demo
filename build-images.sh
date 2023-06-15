#!/bin/sh

set -x
set -e

./mvnw clean package
podman build -t quay.io/andrewazores/quarkus-quickstart-hibernate:jvm-latest -f src/main/docker/Dockerfile.jvm .


./mvnw clean package -Dnative -DskipTests -Dquarkus.native.monitoring=jfr,jmxserver,jmxclient,jvmstat
podman build -t quay.io/roberttoyonaga/jmx:cryostatquarkus -f src/main/docker/Dockerfile.native .
