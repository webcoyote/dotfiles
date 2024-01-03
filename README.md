This repository contains system configuration files -- "dotfiles" for *Linux*, *Mac OSX*, *Windows*, and *Windows Subsystem for Linux* (*WSL*).

There are many solutions to managing dotfiles, each with their own trade-offs. The solution used here is to clone this repository right into your home directory and use git to manage versioning.

# Installation

```
(
    # Halt on errors
    set -euo pipefail

    # Only run the install script one time
    if [[ -d "$HOME/.git" ]]; then
        echo >&2 "ERROR: dotfiles repo already exists ('$HOME/.git')"
        exit 1
    fi

    # Clone repository into a temporary directory
    MYTMPDIR="$(mktemp -d)"
    trap 'rm -rf "$MYTMPDIR"' EXIT
    git clone --no-checkout "git@github.com:webcoyote/dotfiles" "$MYTMPDIR"

    # Configure the repository
    (
        cd "$MYTMPDIR" >/dev/null

        # Rename "origin" so it can be owned by the user
        # and "upstream" will become the original repo
        git remote rename origin upstream

        # Do not show untracked files; the user's home directory
        # may contain thousands of files
        git config --local status.showUntrackedFiles no

        # The home directory contains hundreds of thousands of files
        # in subfolders. Scanning them all takes time, so the gitignore
        # file excludes ... everything. When adding files, this config
        # makes it less annoying to add files
        git config advice.addIgnoredFile false
    )

    # Move repository to home directory
    mv "$MYTMPDIR/.git" "$HOME"

    # Non-destructively update configuration files
    (
        cd "$HOME" >/dev/null
        git ls-files -z -d | xargs -0 git reset -- >/dev/null
        git ls-files -z -d | xargs -0 git checkout -- >/dev/null
        echo -e "\033[36mSUCCESS! Your dotfiles have been updated\033[0m"

        if ! git diff --quiet ; then
            echo -e "\033[33mSome files were NOT overwritten because they contain changes\033[0m"
            git status -sb
        fi
    )
)
```

Use git commands to evaluate file changes, or accept everything with this:

```
cd $HOME
git reset .
git checkout .
```

# Post-installation setup

## Linux and Windows Subsystem for Linux
```
./bin/install/setup-linux

# Windows (run as administrator)
.\bin\install\setup-windows.bat

# Install scripts for various software
ls ./bin/install
```
