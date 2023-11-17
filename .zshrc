# User configuration

##############
# PatW
##############

##############
# Zsh
##############
autoload -Uz +X compinit && compinit

# Case insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# auto-fill the first viable candidate for tab completion
setopt menucomplete

##############
# Shell
##############
export PATH=$HOME/bin:$HOME/bin:/usr/local/bin:$PATH
export EDITOR='vim'

# vi-editing on command line
bindkey -v

# My command aliases
[[ -f "$HOME/.dotfiles/bash_aliases" ]] && source "$HOME/.dotfiles/bash_aliases"

# fast directory jumping
# https://github.com/rupa/z
_Z_DATA="$HOME/.config/z.config"
source "$HOME/bin/z.sh"

# Shell prompt
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Shell history
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# Per-directory environment variables
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# fzf: Ctrl-R replacement for Bash
# https://github.com/junegunn/
# Ctrl-R: search histroy
# Ctrl-T: search files
# Alt-C:  change directory
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

##############
# Git
##############
# Fix zsh bug where tab completion hangs on git commands
# https://superuser.com/a/459057
__git_files () { 
    _wanted files expl 'local files' _files     
}

# GPG for signing git commits
export GPG_TTY=$(tty)

##############
# SSH
##############
# Avoid password prompt *every* *single* *time* for ssh
if [ -f ~/.ssh-agent ]; then
  . ~/.ssh-agent
fi

### NO MORE STUFF BELOW SSH-AGENT
