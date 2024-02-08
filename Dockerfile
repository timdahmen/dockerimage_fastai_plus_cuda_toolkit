ARG BASE_IMAGE=nvidia/cuda:11.8.0-runtime-ubuntu22.04

FROM $BASE_IMAGE

LABEL org.opencontainers.image.authors="Tim Dahmen"
LABEL org.opencontainers.image.source="https://github.com/dmrub/fastai"

ENV NB_USER ${NB_USER:-jovyan}
ENV NB_GROUP ${NB_GROUP:-users}
ENV NB_UID ${NB_UID:-1000}
ENV NB_PREFIX ${NB_PREFIX:-/}
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME 0
ENV HOME /home/$NB_USER
ENV SHELL /bin/bash

# Set shell to bash
SHELL ["/bin/bash", "-c"]

# Create user and set required ownership
RUN useradd -M -s "$SHELL" -N -u ${NB_UID} ${NB_USER}; \
    if [[ -n "$HOME" && ! -d "$HOME" ]]; then \
        mkdir -p "${HOME}"; \
        chown "$NB_USER:$NB_GROUP" -R "$HOME"; \
    fi; \
    if [[ ! -f /etc/sudoers ]] || ! grep -q "^${NB_USER}[[:space:]]" /etc/sudoers; then \
        if [[ ! -f /etc/sudoers ]]; then \
            touch /etc/sudoers; \
        fi; \
        chmod 0660 /etc/sudoers; \
        echo "${NB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
        chmod 0440 /etc/sudoers; \
    fi;

# s6 - 01-copy-tmp-home
RUN set -ex; \
    mkdir -p /tmp_home; \
    cp -r "${HOME}" /tmp_home; \
    chown -R "${NB_USER}:${NB_GROUP}" /tmp_home;

# Set default user
USER $NB_USER

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
