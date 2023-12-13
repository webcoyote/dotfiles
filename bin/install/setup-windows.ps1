function Add-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | where { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | where { $_ }
        $env:Path = $envPaths -join ';'
    }
}

## WORK IN PROGRESS ##

exit /b 1

# check out https://gist.github.com/mikepruett3/7ca6518051383ee14f9cf8ae63ba18a7

if (! (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
   Write-Host "ERROR: you're not an admin"
   exit /b 1
}


########
# Setup HOME directory for use by bash
########
... untested ...
setx HOME ^%USERPROFILE^%
set HOME=^%USERPROFILE^%
...


########
# With admin rights
########
choco install -y 7zip
choco install -y ActivePerl
choco install -y autohotkey
choco install -y chocolateygui
choco install -y cmake
choco install -y ConEmu
choco install -y Console2
choco install -y Firefox
choco install -y git
choco install -y golang
choco install -y GoogleChrome
choco install -y keybase
choco install -y nasm
choco install -y ninja
choco install -y nircmd
choco install -y nodejs
choco install -y notepad2
choco install -y python3
choco install -y ripgrep
choco install -y rufus
choco install -y shellcheck
choco install -y spacesniffer
choco install -y sublimetext3
choco install -y sysinternals
choco install -y truecrypt
choco install -y vcxsrv
choco install -y vscode
choco install -y winmerge
choco install -y yasm

ScoopApps=(
    bat
    delta
    fd
    gh
    grex
    speedcrunch
    starship
)
for app in "${ScoopApps[@]}"; do
    scoop install "$app"
done

CargoApps=(
    atuin
    cargo-update
    eza
    jql
    sd
    tealdeer
    tokei
    zoxide
)
cargo install "${CargoApps[@]}"
cargo install-update -a

# Disable memory compression agent
Disable-MMAgent -mc

# Enable HyperV
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# Enable Windows Subsystem for Linux
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# Enable VirtualMachinePlatform
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

########
# With user rights
########

# Create user "bin" directory
$binPath = Join-Path -Path $env:USERPROFILE -ChildPath "bin"
New-Item -ItemType Directory -Force -Path $binPath
Add-EnvPath -Path $binPath -Container 'User'

# Install wget
$url = "https://eternallybored.org/misc/wget/1.20.3/64/wget.exe"
Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination "$binPath"


# Disable TCP Large Send Offload v2 for WSL because it is broken! 2x faster downloads with this change
Disable-NetAdapterLso -IPv4 -IPv6 -Name "Ethernet"
Disable-NetAdapterLso -IPv4 -IPv6 -Name "vEthernet (WSL)"
Disable-NetAdapterLso -IPv4 -IPv6 -Name "vEthernet (Default Switch)"
Get-NetAdapterLso

# Disable IPv6 for now: Comcast hates it; docker is slow
Disable-NetAdapterBinding –ComponentID ms_tcpip6 –InterfaceAlias "Ethernet"
Disable-NetAdapterBinding –ComponentID ms_tcpip6 –InterfaceAlias "vEthernet (WSL)"
Disable-NetAdapterBinding –ComponentID ms_tcpip6 –InterfaceAlias "vEthernet (Default Switch)"
Get-NetAdapterBinding –ComponentID ms_tcpip6


# if ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
#     Disable-NetAdapterLso -Name "vEthernet (WSL)" -IPv4 -IPv6
#     Get-NetAdapterLso -Name "vEthernet (WSL)"
# } else {
#    Write-Host "ERROR: you're not an admin"
# }

# If you're using WSL to build docker, you may need to disable IPv6 on your Windows
# (not WSL) network adapter to speed up building docker containers. This may only be
# true if you have an ISP (like Comcast/Xfinity) that does not support IPv6.
#
#```
## IPv6 enabled running `make build`
# => [internal] load metadata for docker.io/prefecthq/prefect:0.15.11-python3.8   10.9s
## IPv6 disabled running `make build`
# => [internal] load metadata for docker.io/prefecthq/prefect:0.15.11-python3.8    0.0s
#```
