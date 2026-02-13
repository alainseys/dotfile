FROM python:3.11.13-bullseye

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# ---- Create non-root user matching host UID/GID ----
ARG USERNAME=ansible
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME}

# ---- Install required system packages (single layer) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    openssl \
    git \
    curl \
    sshpass \
    bash-completion \
    less \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# ---- Add custom CA if needed ----
COPY CatoNetworksTrustedRootCA.cer /tmp/CatoNetworksTrustedRootCA.cer
RUN if openssl x509 -in /tmp/CatoNetworksTrustedRootCA.cer -inform DER -noout 2>/dev/null; then \
        openssl x509 -inform DER \
            -in /tmp/CatoNetworksTrustedRootCA.cer \
            -out /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.crt; \
    else \
        cp /tmp/CatoNetworksTrustedRootCA.cer \
           /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.crt; \
    fi && \
    update-ca-certificates && \
    rm -f /tmp/CatoNetworksTrustedRootCA.cer

# ---- Install Docker CLI only (no daemon) ----
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bullseye stable" \
    > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y --no-install-recommends docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# ---- Python config (allow user pip installs safely) ----
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PATH="/home/${USERNAME}/.local/bin:${PATH}"

# ---- Install Ansible & tooling system-wide (clean base layer) ----
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install \
        ansible \
        ansible-lint \
        ansible-dev-tools \
        ansible-builder \
        ansible-creator \
        ansible-navigator \
        pywinrm \
        molecule \
        pyVmomi \
        requests \
        docker \
        netmiko \
        yamllint \
        dnspython \
        pytest-molecule

# ---- Enable bash completion & git completion ----
RUN echo "if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi" >> /etc/bash.bashrc

# ---- Workspace ----
ENV WORKSPACE_BASE_PATH=/workspaces/ansible
RUN mkdir -p ${WORKSPACE_BASE_PATH} \
    && chown -R ${USERNAME}:${USERNAME} ${WORKSPACE_BASE_PATH}

# ---- Switch to non-root user ----
USER ${USERNAME}
WORKDIR ${WORKSPACE_BASE_PATH}
