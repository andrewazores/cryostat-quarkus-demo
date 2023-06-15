#!/bin/sh

set -x
set -e

if [ -z "${GRAALVM_HOME}" ]; then
  echo "\$GRAALVM_HOME is not set. This build is likely to fail." >&2
  sleep 3
fi

./mvnw clean package
podman pull registry.access.redhat.com/ubi8/openjdk-11:1.15
podman build -t quay.io/andrewazores/quarkus-quickstart-hibernate:jvm-latest -f src/main/docker/Dockerfile.jvm .

./mvnw clean package -Dnative -DskipTests -Dquarkus.native.monitoring=jfr,jmxserver,jmxclient,jvmstat
podman pull registry.access.redhat.com/ubi9/ubi-minimal:9.2
podman build -t quay.io/andrewazores/quarkus-quickstart-hibernate:native-latest -f src/main/docker/Dockerfile.native .

podman image prune -f
