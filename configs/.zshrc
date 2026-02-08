# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# App Images Location (need to exists)
export PATH="$HOME/Application:$PATH"
ZSH_THEME="powerlevel10k/powerlevel10k"
ssh-add -l &>/dev/null || ssh-add ~/.ssh/alainseys_HP_HCD4097VMK_private_openssh
#===============================================================================
# FUNCTIONS
# =============================================================================
addfile(){
 ~/.dotfiles/scripts/add.sh "$1"
}

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker)
source $ZSH/oh-my-zsh.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
#===================================================
# Preferred editor for local and remote sessions
#===================================================
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,

# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# ==============================================
# PRIVATE ALIASES (NOT SYNCED)
# =============================================
PRIVATE_ALIASES="$HOME/.zshrc.private"
if [[ -f "$PRIVATE_ALIASES" ]]; then
	source "$PRIVATE_ALIASES"
else
	echo "Private aliased file not found $PRIVATE_ALIASES"
fi

#===============================================
# ALIASSES
#===============================================
alias edit-private-alias="vi ~/.zshrc.private"
alias edit-zsh="vi ~/.zshrc"
alias update-zsh="source ~/.zshrc"
alias watchconfig="$HOME/.dotfile/scripts/watch-configs.sh"
alias cato="$HOME/.dotfile/scripts/sdp.sh"

alias umount-veeam-disk="sudo umount -l /mnt/WDBACKUP"
alias mount-veeam-disk="sudo mount -a"
alias start-veeam="sudo veeam"
alias new-project="$HOME/.dotfile/scripts/new-project.sh"
alias dotcommit='cd $HOME/.dotfile && git add -A && git commit -m "Update dotfiles: $(date)" && git push'
alias dotadd="$HOME/.dotfile/scripts/add.sh"
#test
#==================================================
# Appimage Applications
# ================================================
alias obsidian="~/.Applications/Obsidian-1.11.7.AppImage"

#====================================================
# Powerlevel
#===================================================
source $HOME/.oh-my-zsh/custom/themes/powerlevel10k
source $HOME/.oh-my-zsh/custom/themes/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
