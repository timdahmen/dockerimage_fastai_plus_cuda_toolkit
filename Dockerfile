ARG BASE_IMAGE=nvidia/cuda:12.3.1-devel-ubuntu22.04

FROM $BASE_IMAGE

LABEL org.opencontainers.image.authors="Tim Dahmen"
LABEL org.opencontainers.image.source="https://github.com/dmrub/fastai"

# Set shell to bash
SHELL ["/bin/bash", "-c"]

RUN set -ex; \
    apt-get -y update; \
	apt-get install -y --no-install-recommends \
		cmake; \
    apt-get install -y --no-install-recommends \
        python3 python3-dev python-pybind11 python3-pip; \
    apt-get clean; 
	
RUN set -ex; \	
    rm -rf /var/lib/apt/lists/*;

RUN set -ex; \
    pip3 install tifffile fastai torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118;

ENTRYPOINT ["/bin/bash"]
