FROM python:3.11.13-bullseye

# ----------------------------------------
# Add trusted root CA
# ----------------------------------------
COPY CatoNetworksTrustedRootCA.cer /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.cer
RUN apt-get update && apt-get install -y ca-certificates openssl && \
    if openssl x509 -in /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.cer -inform DER -noout 2>/dev/null; then \
        openssl x509 -inform DER -in /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.cer \
                     -out /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.crt; \
    else \
        cp /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.cer \
           /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.crt; \
    fi && \
    rm -f /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.cer && \
    update-ca-certificates

# ----------------------------------------
# Set workspace
# ----------------------------------------
ENV WORKSPACE_BASE_PATH=/workspaces/ansible
WORKDIR ${WORKSPACE_BASE_PATH}

# ----------------------------------------
# Install dependencies
# ----------------------------------------
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sshpass \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        less \
        software-properties-common \
        openssh-client \
        git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------------------------------------
# Install Docker CLI for Molecule
# ----------------------------------------
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && apt-get install -y docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------------------------------------
# Install Python packages
# ----------------------------------------
RUN python3 -m pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install ansible ansible-lint ansible-dev-tools ansible-builder ansible-creator ansible-navigator \
    pywinrm molecule pyVmomi requests docker netmiko yamllint dnspython pytest-molecule

# ----------------------------------------
# Git configuration
# ----------------------------------------
RUN git config --global user.email "alain.seys@outlook.com" && \
    git config --global user.name "Alain Seys"

# ----------------------------------------
# Copy private SSH key and configure SSH
# ----------------------------------------
COPY ../private_key /root/.ssh/id_ed25519
RUN chmod 600 /root/.ssh/id_ed25519

# SSH config to force GitLab to use the key directly (no ssh-agent needed)
RUN mkdir -p /root/.ssh && \
    cat > /root/.ssh/config <<'EOF'
Host ans-gitlab-01.vanmarcke.be
    User git
    IdentityFile /root/.ssh/id_ed25519
    IdentitiesOnly yes
    PubkeyAuthentication yes
    PasswordAuthentication no
EOF
RUN chmod 600 /root/.ssh/config

# ----------------------------------------
# Bash aliases and environment variables
# ----------------------------------------
RUN echo "alias ansible-update='git push origin HEAD:main'" >> /etc/bash.bashrc && \
    echo "export ANSIBLE_CONFIG=${WORKSPACE_BASE_PATH}/ansible.cfg" >> /etc/bash.bashrc && \
    echo "alias ansible-submodules='${WORKSPACE_BASE_PATH}/scripts/ansible-submodules.sh'" >> /etc/bash.bashrc

# ----------------------------------------
# Optional: allow SSHD access
# ----------------------------------------
RUN echo 'SSHD: ALL' >> /etc/hosts.allow
