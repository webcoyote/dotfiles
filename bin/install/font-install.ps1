#!/usr/bin/env powershell.exe
#Requires -Version 5.0

[CmdletBinding(SupportsShouldProcess)]
param ()

Set-strictmode -version latest


# Elevate script to run as administrator
$windowsId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($windowsId)
if (! $windowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Re-run this script with administrative permissions.
    $arguments = "& '" +$myinvocation.mycommand.definition + "'"
    Start-Process powershell.exe -Wait -Verb RunAs -ArgumentList $arguments
    exit
}

$fontUrl="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/BitstreamVeraSansMono/Regular/complete/Bitstream%20Vera%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf"

# Download the font
$fontName = [uri]::UnescapeDataString($fontUrl.Substring($fontUrl.LastIndexOf("/") + 1))
$fontFile = Join-Path $env:TEMP $fontName
if (! (Test-Path -PathType Leaf -Path $fontFile)) {
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontFile
}

if ($PSCmdlet.ShouldProcess($fontFile, "Install Font")) {
    if (!(test-path variable:\fonts)) {
        $shellApp = New-Object -ComObject shell.application
        $fonts = $shellApp.NameSpace(0x14)
    }
    try {
        $fonts.CopyHere($fontFile)
    } Catch {
        Write-Host $_.Exception
    }
}

#######################################
# Complete
#######################################
Write-Host -ForegroundColor Cyan "Success"
Start-Sleep -Seconds 2
