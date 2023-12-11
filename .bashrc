#!/bin/bash
#(set -o igncr) 2>/dev/null && set -o igncr; # Cygwin fix; comment is needed!
#export SHELLOPTS

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# DISABLE lesspipe: on Linux, 'less' can probably get you owned
# https://seclists.org/fulldisclosure/2014/Nov/74
### make less more friendly for non-text input files, see lesspipe(1)
### [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  #PS1='\w\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  # PS1='\[\033[01;36m\]\w\[\033[00m\]\$ '
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
  *)
  ;;
esac

# enable color support of ls and also add handy aliases
#if [ -x /usr/bin/dircolors ]; then
#    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#    alias ls='ls --color=auto'
#    alias grep='grep --color=auto'
#    alias fgrep='fgrep --color=auto'
#    alias egrep='egrep --color=auto'
#fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# HOSTNAME is not an environment variable, it is a bash internal variable,
# and so programs like docker-compose cannot use it during environment
# variable interpolation! Let's fix this here:
export HOSTNAME

# Do not leave the shell when pressing Ctrl-D once (must press twice)
export IGNOREEOF=1

# Prevent curl from whining about certificates:
# https://stackoverflow.com/questions/3160909/how-do-i-deal-with-certificates-using-curl-while-trying-to-access-an-https-url#comment59801161_3160909
CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
if [[ -f "$CURL_CA_BUNDLE" ]]; then
  export CURL_CA_BUNDLE
else
  unset CURL_CA_BUNDLE
fi

# Configure XWindows for WSL1 ("Microsoft") or WSL2 ("microsoft")
# if [[ $(uname -r) =~ icrosoft ]]; then
#     source "$HOME/bin/vcxsrv"
# fi

# These settings do not work in Git-Bash when included in .inputrc, so set them here in .bashrc
bind "Space: magic-space"                   # expand history when pressing space
bind "Tab: menu-complete"                   # modern tab-completion
bind "set editing-mode vi"                  # instead of emacs
bind "set bell-style none"                  # disable bell
bind "set completion-ignore-case on"        # case-insensitive tab completion
bind "set completion-map-case on"           # treat - and _ as equivalent for tab completion
bind "set mark-directories on"              # add slash after tab-completed directory
bind "set mark-symlinked-directories on"    # add slash after tab-completed symlinked-directory
bind "set show-all-if-ambiguous on"         # show matches on tab immediately
bind "set show-all-if-unmodified on"        # show matches on tab immediately
bind "set match-hidden-files off"           # do not match hidden files unless '.' prefixed

# Even without accessibility enabled many Gnome components try to connect to the AT-SPI bus and display:
# WARNING **: Could not register with accessibility bus: Did not receive a
# reply. Possible causes include: the remote application did not send a
# reply, the message bus security policy blocked the reply, the reply
# timeout expired, or the network connection was broken.
# To get these messages no longer displayed, the following entry is /etc/environmentrequired in the.
export NO_AT_BRIDGE=1

# Fix for Windows git-bash
export USER="${USER:-$USERNAME}"

case "$OSTYPE" in
  linux*)
    # Simulate OSX's pbcopy/pbpaste on other platforms
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'

    # Common alias across all platforms to open something
    alias ']'=xdg-open

    # Tools
    export DIFFTOOL="meld"
    export MERGETOOL="meld"
  ;;

  darwin*)
    # Common alias across all platforms to open something
    alias ']'=open
  ;;

  msys*|cygwin*)
    # Common alias across all platforms to open something
    alias ']'=start

    # Tools
    export DIFFTOOL="meld"
    export MERGETOOL="meld"
  ;;
esac

# goto home directory (needed for WSL)
\cd "$HOME"

# cd command should only tab-complete directories
complete -d cd

# enable bash command-hooks
[[ -f "$HOME/bin/bash-preexec.sh" ]] && source "$HOME/bin/bash-preexec.sh"

# aliases for bash/zsh
[[ -f "$HOME/.dotfiles/bash_aliases" ]] && source "$HOME/.dotfiles/bash_aliases"
