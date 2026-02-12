FROM python:3.11.13-bullseye

# Install Podman and dependencies
RUN apt-get update && \
    apt-get install -y podman sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install required dependencies and set up CA certificates
COPY CatoNetworksTrustedRootCA.pem /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.crt
RUN apt-get update && apt-get install -y ca-certificates openssl && \
    cp /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.crt /usr/local/share/ca-certificates/CatoNetworksTrustedRootCA.pem && \
    update-ca-certificates

# Install sshpass and kerberos requirements
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass \
    gcc python3-dev libkrb5-dev gss-ntlmssp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user - DO THIS EARLY
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user and set up permissions
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Add user to podman group
    && groupadd -r podman 2>/dev/null || true \
    && usermod -aG podman $USERNAME 2>/dev/null || true \
    # Create podman socket directory
    && mkdir -p /run/user/$USER_UID/podman \
    && chown -R $USERNAME:$USERNAME /run/user/$USER_UID \
    # Change shell to bash
    && chsh -s /bin/bash $USERNAME

# Set up sudo for podman
RUN echo "$USERNAME ALL=(root) NOPASSWD: /usr/bin/podman" >> /etc/sudoers.d/$USERNAME-podman

# Set the workspace environment variable
ENV WORKSPACE_BASE_PATH=/workspaces/ansible

# Copy the private key into the image (commented out)
# COPY --chown=$USERNAME:$USERNAME ../private_key ${WORKSPACE_BASE_PATH}/private_key
# RUN chmod 600 ${WORKSPACE_BASE_PATH}/private_key

# Configure SSH agent for non-root user
# RUN echo "eval \$(ssh-agent -s)" >> /home/$USERNAME/.bashrc && \
#    echo "ssh-add ${WORKSPACE_BASE_PATH}/private_key 2>/dev/null || true" >> /home/$USERNAME/.bashrc

# NOW switch to non-root user for pip installations
USER $USERNAME
WORKDIR /home/$USERNAME

# Upgrade pip and install Python packages
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --user \
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
    podman

# Set up bash aliases and environment variables
RUN echo "alias ansible-update='git push origin HEAD:main'" >> /home/$USERNAME/.bashrc
RUN echo "export ANSIBLE_CONFIG=${WORKSPACE_BASE_PATH}/ansible.cfg" >> /home/$USERNAME/.bashrc
RUN echo "alias ansible-submodules='${WORKSPACE_BASE_PATH}/scripts/ansible-submodules.sh'" >> /home/$USERNAME/.bashrc

# Git configuration
RUN git config --global user.email "alain.seys@outlook.com"
RUN git config --global user.name "Alain Seys"

# Copy and install Python requirements
COPY --chown=$USERNAME:$USERNAME requirements.txt /tmp/requirements.txt
RUN pip install --user -r /tmp/requirements.txt

# Switch back to root for final setup (if needed)
USER root
# Any root commands here if needed

# Switch back to non-root user for runtime
USER $USERNAME
WORKDIR ${WORKSPACE_BASE_PATH}