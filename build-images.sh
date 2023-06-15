#!/bin/sh

set -x
set -e

if [ -z "${GRAALVM_HOME}" ]; then
  echo "\$GRAALVM_HOME is not set. This build is likely to fail." >&2
  sleep 3
fi

./mvnw clean package
podman build -t quay.io/andrewazores/quarkus-quickstart-hibernate:jvm-latest -f src/main/docker/Dockerfile.jvm .

./mvnw clean package -Dnative -DskipTests -Dquarkus.native.monitoring=jfr,jmxserver,jmxclient,jvmstat
podman build -t quay.io/roberttoyonaga/jmx:cryostatquarkus -f src/main/docker/Dockerfile.native .

podman image prune -f
