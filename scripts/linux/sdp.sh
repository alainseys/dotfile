#!/bin/bash

clear

echo "==========================================================="
echo "                   SDP COMMANDER v1.1.0                    "
echo "==========================================================="
echo " This utility connects/disconnects to CATO SDP "
echo

# ------------------------------------------------------------
# Functions
# ------------------------------------------------------------

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID=$ID
        OS_LIKE=$ID_LIKE
    else
        echo "Unable to detect operating system."
        exit 1
    fi
}

is_installed() {
    command -v cato-sdp >/dev/null 2>&1
}

install_client() {
    echo "Cato SDP client not found. Installing..."

    if [[ "$OS_ID" =~ (debian|ubuntu) ]] || [[ "$OS_LIKE" =~ debian ]]; then
        echo "Detected Debian-based system"
        TMP_FILE="/tmp/cato-client-install.deb"
        curl -fsSL https://clientdownload.catonetworks.com/public/clients/cato-client-install.deb -o "$TMP_FILE" \
            || { echo "Download failed"; exit 1; }
        sudo dpkg -i "$TMP_FILE" || sudo apt -f install -y

    elif [[ "$OS_ID" =~ (rhel|centos|rocky|almalinux|fedora) ]] || [[ "$OS_LIKE" =~ rhel ]]; then
        echo "Detected RHEL-based system"
        TMP_FILE="/tmp/cato-client-install.rpm"
        curl -fsSL https://clientdownload.catonetworks.com/public/clients/cato-client-install.rpm -o "$TMP_FILE" \
            || { echo "Download failed"; exit 1; }
        sudo rpm -ivh "$TMP_FILE" || sudo dnf install -y "$TMP_FILE"

    else
        echo "Unsupported OS: $OS_ID"
        exit 1
    fi

    if is_installed; then
        echo "Cato SDP client installed successfully."
    else
        echo "Installation failed."
        exit 1
    fi
}

# ------------------------------------------------------------
# Pre-flight checks
# ------------------------------------------------------------

detect_os

if ! is_installed; then
    install_client
fi

# ------------------------------------------------------------
# Menu
# ------------------------------------------------------------

PS3="Choose an option (1-4): "

select OPTION in "Start SDP" "Stop SDP" "Status" "Quit"; do
    echo
    case "$REPLY" in
        1)
            echo "Starting SDP..."
            echo "==========================================================="
            cato-sdp start
            ;;
        2)
            echo "Stopping SDP..."
            echo "==========================================================="
            cato-sdp stop
            ;;
        3)
            echo "SDP Status:"
            echo "==========================================================="
            cato-sdp status
            ;;
        4)
            echo "SDP Terminated ... Goodbye."
            break
            ;;
        *)
            echo "Invalid choice. Try again."
            ;;
    esac
    echo
    echo "==========================================================="
done
