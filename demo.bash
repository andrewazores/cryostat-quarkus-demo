#!/usr/bin/env bash
# shellcheck disable=SC2086

set -x
set -e

mapfile -t COMPOSE < <(ls -1 ./compose-*.yml)
flags=$(printf -- "-f %s " "${COMPOSE[@]}")

teardown() {
  if podman volume exists cryostat_quarkus_demo; then
    podman volume rm -f cryostat_quarkus_demo
  fi
  docker-compose $flags down --volumes --remove-orphans
  rm -f "${tmp}"
}
teardown
trap teardown EXIT

vol="$(podman volume create cryostat_quarkus_demo)"
tmp="$(mktemp)"
tar cf "${tmp}" extras/*.jar
podman volume import "${vol}" "${tmp}"

docker-compose $flags up
