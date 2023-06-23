#!/usr/bin/env bash
# shellcheck disable=SC2086

set -x
set -e

REQUIREMENTS=(
  "podman"
  "docker-compose"
)

for req in "${REQUIREMENTS[@]}"; do
  if ! command -v "${req}"; then
    echo -e "\n\t'${req}' not found\n"
    exit 1
  fi
done


mapfile -t COMPOSE < <(ls -1 ./compose-*.yml)
flags=$(printf -- "-f %s " "${COMPOSE[@]}")

# requires https://github.com/figiel/hosts
if [ -f "$HOME/bin/libuserhosts.so" ]; then
  export LD_PRELOAD=$HOME/bin/libuserhosts.so
fi

original_hosts="$(cat ~/.hosts)"

extras_volume="cryostat_quarkus_demo"

teardown() {
  echo -n "${original_hosts}" > ~/.hosts
  if podman volume exists "${extras_volume}"; then
    podman volume rm -f "${extras_volume}"
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

vol="$(podman volume create "${extras_volume}")"
tmp="$(mktemp)"
tar cf "${tmp}" extras/*.jar
podman volume import "${vol}" "${tmp}"

docker-compose $flags up
