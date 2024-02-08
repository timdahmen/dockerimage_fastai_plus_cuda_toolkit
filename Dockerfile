ARG BASE_IMAGE=nvidia/cuda:11.8.0-runtime-ubuntu22.04

FROM $BASE_IMAGE

LABEL org.opencontainers.image.authors="Tim Dahmen"
LABEL org.opencontainers.image.source="https://github.com/dmrub/fastai"

RUN set -ex; \
    apt-get -y update; \
    apt-get install -y --no-install-recommends \
        python3 python3-pip; \
    apt-get clean; \
    apt-get install -y --no-install-recommends \
        cuda-toolkit nvidia-gds;
    rm -rf /var/lib/apt/lists/*;

RUN set -ex; \
    pip3 install tifffile fastai torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118;

ENTRYPOINT ["/bin/bash"]
