@echo off
:: It's useful to have batch files that are launched from explorer pause before
:: exiting so it's possible to review the results, but inconvenient to pause
:: when run from the command-line because or when called from other batch files.
::
:: This script will cause the command interpreter to pause when the user runs
:: it (or it's parent) by double-clicking
for /F "tokens=2" %%a in ("%cmdcmdline%") do if /I "%%a" == "/c" pause
