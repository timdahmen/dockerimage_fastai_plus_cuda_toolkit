ARG BASE_IMAGE=nvidia/cuda:11.8.0-runtime-ubuntu22.04

FROM $BASE_IMAGE

LABEL org.opencontainers.image.authors="Dmitri Rubinstein"
LABEL org.opencontainers.image.source="https://github.com/dmrub/fastai"

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3 python3-pip; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*;

RUN set -ex; \
    pip3 install fastai torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118;

ENTRYPOINT ["/bin/bash"]
