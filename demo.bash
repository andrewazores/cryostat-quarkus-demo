#!/usr/bin/env bash
# shellcheck disable=SC2086

set -x
set -e

mapfile -t COMPOSE < <(ls -1 ./compose-*.yml)
flags=$(printf -- "-f %s " "${COMPOSE[@]}")

teardown() {
    docker-compose $flags down --volumes --remove-orphans 
}
teardown
trap teardown EXIT

docker-compose $flags up
