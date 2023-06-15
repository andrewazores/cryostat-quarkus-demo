#!/bin/sh

set -x
set -e

./mvnw clean package
podman build -t quay.io/andrewazores/quarkus-quickstart-hibernate:jvm-latest -f src/main/docker/Dockerfile.jvm .


./mvnw -Dnative clean package
podman build -t quay.io/andrewazores/quarkus-quickstart-hibernate:native-latest -f src/main/docker/Dockerfile.native .
