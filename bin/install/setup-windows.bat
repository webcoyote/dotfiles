@echo off

net session >nul 2>&1
if "%ErrorLevel%" NEQ "0" (
    echo ERROR: Administrator permissions required
    exit /b 1
)

where choco.exe >nul 2>&1
if "%ErrorLevel%" NEQ "0" (
    echo ERROR: Chocolatey not installed
    echo https://chocolatey.org/install
    exit /b 1
)

choco.exe install -y ^
    7zip ^
    autohotkey ^
    dbeaver ^
    git ^
    irfanview ^
    jq ^
    make ^
    microsoft-windows-terminal ^
    notepad2 ^
    ripgrep ^
    shellcheck ^
    sublimetext3 ^
    sysinternals ^
    wget ^
    winmerge ^
    wiztree ^
#

# Atuin
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
