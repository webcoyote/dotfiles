This repository contains system configuration files -- "dotfiles" for *Linux*, *Mac OSX*, *Windows*, and *Windows Subsystem for Linux* (*WSL*).

There are many solutions to managing dotfiles, each with their own trade-offs. This solution clone this repository right into $HOME.

# Installation

```bash
curl -fsSL https://raw.githubusercontent.com/webcoyote/dotfiles/main/bin/install/dotfiles | bash
```

This will:
- Clone the repository to a temporary directory
- Move `.git` to your home directory
- Non-destructively checkout dotfiles (preserves any local changes)
- Configure git to ignore untracked files in your home directory

# Post-installation setup

After installing dotfiles, run the platform-specific setup script:

```bash
# macOS
./bin/install/setup-osx

# Linux / WSL
./bin/install/setup-linux

# Windows (run as administrator)
./bin/install/setup-windows.bat
```
