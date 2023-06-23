#!/usr/bin/env bash
# shellcheck disable=SC2086

set -x
set -e

mapfile -t COMPOSE < <(ls -1 ./compose-*.yml)
flags=$(printf -- "-f %s " "${COMPOSE[@]}")

# requires https://github.com/figiel/hosts
export LD_PRELOAD=$HOME/bin/libuserhosts.so

original_hosts="$(cat ~/.hosts)"

teardown() {
  echo -n "${original_hosts}" > ~/.hosts
  if podman volume exists cryostat_quarkus_demo; then
    podman volume rm -f cryostat_quarkus_demo
  fi
  docker-compose $flags down --volumes --remove-orphans
  rm -f "${tmp}"
}
teardown
trap teardown EXIT

setupUserHosts() {
    echo -e "\nlocalhost grafana\nlocalhost cryostat" >> ~/.hosts
}
setupUserHosts

vol="$(podman volume create cryostat_quarkus_demo)"
tmp="$(mktemp)"
tar cf "${tmp}" extras/*.jar
podman volume import "${vol}" "${tmp}"

docker-compose $flags up
