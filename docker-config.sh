# shellcheck shell=bash
############### Configuration ###############

# shellcheck disable=SC2034
BASE_IMAGE=nvidia/cuda:11.8.0-runtime-ubuntu22.04

# IMAGE_PREFIX=${IMAGE_PREFIX:-}

BASE_IMAGE_TAG=${BASE_IMAGE#*:};
BASE_IMAGE_NAME=${BASE_IMAGE%%:*};
case "$BASE_IMAGE_NAME" in
  nvidia/cuda) IMAGE_NAME=fastai;;
  *) echo >&2 "Error: unknown base image: $BASE_IMAGE_NAME"; exit 1;;
esac;

IMAGE_TAG=${IMAGE_TAG:-${BASE_IMAGE_TAG}}

# shellcheck disable=SC2034
IMAGE=${IMAGE_PREFIX}${IMAGE_NAME}${IMAGE_TAG+:}${IMAGE_TAG}
############# End Configuration #############
