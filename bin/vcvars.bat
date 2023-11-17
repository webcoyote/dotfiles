@echo off

if "%1" == "" (
  set MSVC_VERSION=12
) else (
  set MSVC_VERSION=%1
)
"c:\Program Files (x86)\Microsoft Visual Studio %MSVC_VERSION%.0\VC\vcvarsall.bat"
