:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

set -Eeuo pipefail
root="$(cd "$(dirname "$0")"; pwd)"
echo "I'm a bash script running from the directory $root"
exit 0
:CMDSCRIPT

echo I'm a batch file running from the directory %~dp0
EXIT /B %ERRORLEVEL%
