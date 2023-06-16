#!/usr/bin/env bash

set -e

if ! command -v http; then
    echo "HTTPie ('http') is missing"
    exit 1
fi

if ! command -v jq; then
    echo "'jq' is missing"
    exit 1
fi

if ! command -v openssl; then
    echo "'openssl' is missing"
    exit 1
fi

if [ $# -ne 2 ]; then
    echo "Two arguments ('port_number' and 'num_runs') required"
    exit 1
fi

port=":$1"
runs="$2"

http "${port}/fruits"

ids=()

cleanup() {
    for id in "${ids[@]}"; do
        http DELETE "${port}/fruits/${id}" >/dev/null 2>&1
    done
}
trap cleanup EXIT

for run in $(seq "${runs}"); do
    name="$(openssl rand -base64 12)"
    id="$(http :8080/fruits name="${name}" | jq '.id')"
    ids+=("${id}")
done
