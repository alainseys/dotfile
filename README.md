
# Dot files
This repo is created to store my laptop configurations, so i can verry fast restore my settings in case when i need to reset my system.
## Installation
On Windows i use WSL make sure you clone the repository in the correct directory ($HOME/.dotfiles), otherwise the script will not work!
On Linux the same applies the directory should be inside your home folder as above.
#
## Prequisties
- copy private ssh key to ~/.ssh (if no ssh folder run ssh-keygen)
- copy ssh config to ~/.ssh and define your git providers with your ssh key
- Install zsh (``apt-get install zsh or dnf install zsh``)
- Install ohmyzsh (``https://ohmyz.sh/#install``)
- Clone ``git clone git@github.com:alainseys/dotfile.git $HOME/.dotfiles``
- Run ``./setup-auto-sync.sh``
- Update /scripts/watch-config:qs.conf with the paths you want to watch for
- Copy zshrc file to ~/.zshrc
- Source the file source ~/.zshrc
