param(
    [string]$Dir
)

if( !(Test-Path $Dir) ){
    Write-warning "Supplied directory was not found!"
    return
}
$PATH = [Environment]::GetEnvironmentVariable("PATH")
if( $PATH -notlike "*"+$Dir+"*" ){
    [Environment]::SetEnvironmentVariable("PATH", "$PATH;$Dir", "User")
}
