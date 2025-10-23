@echo off
setlocal

:: Make sure git utilities precede windows utilities in the path
set GitDir=C:\Program Files (x86)\Git\bin
set Path=%GitDir%;%Path%

:: Replace backslashes with forward slashes in the name of the script
:: so that bash can extract the correct value for ${BASH_SOURCE[0]}
set SCRIPT_NAME=%~dpn0.sh
set SCRIPT_NAME=%SCRIPT_NAME:\=/%

:: Execute the script and explicitly capture the error code
"C:\Program Files\Git\Bin\bash.exe" "%SCRIPT_NAME%" %*
set SCRIPT_ERROR_CODE=%ERRORLEVEL%

:: Explicitly check for 'command not found'
if %SCRIPT_ERROR_CODE%==9009 echo ERROR: bash not found. Install Git, which includes bash

:: Return the script error code
exit /b %SCRIPT_ERROR_CODE%
