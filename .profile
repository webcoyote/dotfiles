# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Fix PATH for Windows bash implementations
case "$OSTYPE" in
  msys*)
    # Add git-bash bin to the head of the path so that git-bash utilities are
    # found before any Windows utilities of the same name
    [[ -d "/bin" ]] && export PATH="/bin:$PATH"
  ;;

  cygwin*)
    # Remove git-bash utilities since we're running cygwin
    export PATH=${PATH/":/cygdrive/c/Program Files (x86)/Git/bin"}
    export PATH=${PATH/":/cygdrive/c/Program Files/Git/usr/bin"}
    export PATH=${PATH/":/cygdrive/c/Program Files/Git/bin"}
  ;;

  linux*)
    # Remove git-bash utilities since we're running linux
    export PATH=${PATH/":/mnt/c/Program Files/Git/cmd"}
    export PATH=${PATH/":/mnt/c/Program Files/Git LFS"}
    export PATH=${PATH/":/mnt/c/Program Files/Git/usr/bin"}
    export PATH=${PATH/":/mnt/c/Program Files/Git/bin"}

    # In WSL, remove "Gow" (Gnu-on-Windows) utilies as they conflict with Linux
    export PATH=${PATH/":/mnt/c/Program Files (x86)/Gow/bin"}
  ;;
esac

# The Nix installer will add a line similar to this one to the end of this file,
# but we need to source it before .bashrc in order for direnv to work properly,
# since we install direnv with Nix. Note that if Nix does add a similar line at
# the end, you can leave it or delete it.
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Start cron on WSL with the help of "/etc/sudoers.d/wsl-start-cron".
# Cron is used to run apt-cron, which performs background OS updates.
#if [[ $(uname -r) =~ icrosoft ]]; then
#    if [[ -f /etc/sudoers.d/wsl-start-cron ]]; then
#        sudo /etc/init.d/cron start &
#    else
#        echo >&2 "ERROR: run '$HOME/bin/install/setup-linux' to setup cron"
#    fi
#fi

# Add my bin directories
PATH="$HOME/bin:$PATH"

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# One More Game
export OMG_CONFIG_PATH="$HOME/.config/omg"

if [ -f "$OMG_CONFIG_PATH/env" ]; then
  source "$OMG_CONFIG_PATH/env"
fi

if [ -f "$OMG_CONFIG_PATH/secrets" ]; then
  source "$OMG_CONFIG_PATH/secrets"
fi

if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

# if running bash, include .bashrc if it exists
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

# Nix
if [ -e /home/pat/.nix-profile/etc/profile.d/nix.sh ]; then . /home/pat/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
