##############
# Zsh
##############
autoload -Uz +X compinit && compinit

# Case insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# auto-fill the first viable candidate for tab completion
setopt menucomplete

# vi-editing on command line
bindkey -v

# Fix zsh bug where tab completion hangs on git commands
# https://superuser.com/a/459057
__git_files () {
    _wanted files expl 'local files' _files
}

# Only allow unique entries in path
typeset -U path

# aliases for bash/zsh
[[ -f "$HOME/.dotfiles/bash_aliases" ]] && source "$HOME/.dotfiles/bash_aliases"

# NPM completions
[[ -f "$HOME/.dotfiles/npm_completions" ]] && source "$HOME/.dotfiles/npm_completions"
