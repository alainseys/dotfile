#!/bin/bash
# Setup dotfiles on a new system

set -e  # Exit on error

echo "🚀 Setting up dotfiles on new system..."
echo "========================================"

# 1. Clone dotfiles repo
echo "📦 Cloning dotfiles repository..."
cd ~
if [ -d ~/.dotfiles ]; then
    echo "⚠  .dotfiles already exists, backing up..."
    mv ~/.dotfiles ~/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)
fi

git clone git@github.com:alainseys/dotfile.git .dotfiles

# 2. Install dependencies
echo "📦 Installing dependencies..."
if command -v dnf &> /dev/null; then
    sudo dnf install -y zsh vim git curl
elif command -v yum &> /dev/null; then
    sudo yum install -y zsh vim git curl
elif command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y zsh vim git curl
fi

# 3. Restore dotfiles
echo "🔄 Restoring configuration files..."
cd ~/.dotfiles

# Copy files from configs to home directory
for file in configs/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        case $filename in
            "zshrc")
                cp "$file" ~/.zshrc
                echo "✓ Installed .zshrc"
                ;;
            "vimrc")
                cp "$file" ~/.vimrc
                echo "✓ Installed .vimrc"
                ;;
            "bashrc")
                cp "$file" ~/.bashrc
                echo "✓ Installed .bashrc"
                ;;
            "ansible")
                cp "$file" ~/.ansible.cfg
                echo "✓ Installed .ansible.cfg"
                ;;
            "docker")
                mkdir -p ~/.docker
                cp "$file" ~/.docker/config.json
                echo "✓ Installed docker config"
                ;;
            *)
                # Generic copy for other files
                cp "$file" ~/."$filename"
                echo "✓ Installed .$filename"
                ;;
        esac
    fi
done

# 4. Make sync script executable
echo "🔧 Setting up sync script..."
if [ -f ~/.dotfiles/sync.sh ]; then
    chmod +x ~/.dotfiles/sync.sh
    # Add alias to zshrc
    echo -e "\n# Dotfiles alias" >> ~/.zshrc
    echo "alias dot-sync='~/.dotfiles/sync.sh'" >> ~/.zshrc
    echo "✓ Added 'dot-sync' alias"
fi

# 5. Optional: Change shell to zsh
echo "💻 Changing shell to zsh..."
if command -v chsh &> /dev/null; then
    chsh -s $(which zsh)
    echo "✓ Shell changed to zsh"
fi

# 6. Install optional tools
echo "🛠️  Installing optional tools..."
read -p "Install extra tools? (docker, ansible, etc) [y/N]: " install_extra
if [[ $install_extra =~ ^[Yy]$ ]]; then
    if command -v dnf &> /dev/null; then
        echo "Installing Docker and Ansible..."
        sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io ansible
        sudo systemctl enable --now docker
        sudo usermod -aG docker $USER
    fi
fi

echo ""
echo "✅ Setup complete!"
echo "📝 Next steps:"
echo "   1. Log out and back in for shell changes"
echo "   2. Run 'source ~/.zshrc' to load new config"
echo "   3. Use 'dot-sync' to sync changes back to repo"
echo "   4. Edit files in ~/.dotfiles/configs/ and run sync"

# 7. Source new zshrc
echo ""
read -p "Source ~/.zshrc now? [Y/n]: " source_zshrc
if [[ ! $source_zshrc =~ ^[Nn]$ ]]; then
    source ~/.zshrc
    echo "✓ Sourced .zshrc"
fi
