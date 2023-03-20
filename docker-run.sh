#!/usr/bin/env bash

set -eo pipefail

THIS_DIR=$( cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )

error() {
    echo >&2 "* Error: $*"
}

fatal() {
    error "$@"
    exit 1
}

message() {
    echo "* $*"
}

usage() {
    echo "./docker-run.sh [--net=*] [--as-root] [--]"
}


# shellcheck source=docker-config.sh
source "$THIS_DIR/docker-config.sh" || \
    fatal "Could not load configuration from $THIS_DIR/docker-config.sh"


ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --net=*)
            ARGS+=("$1")
            shift
            ;;
        --help)
            usage
            exit
            ;;
        --)
            shift
            break
            ;;
        -*)
            fatal "Unknown option $1"
            ;;
        *)
            break
            ;;
    esac
done

echo "Image Configuration:"
echo "IMAGE_NAME:        $IMAGE_NAME"
echo "IMAGE:             $IMAGE"

set -x
docker run --rm -it  \
    --gpus=all \
    "${ARGS[@]}" \
    "$IMAGE"
